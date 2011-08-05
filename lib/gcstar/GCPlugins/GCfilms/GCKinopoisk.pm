package GCPlugins::GCfilms::GCKinopoisk;

use strict;
use utf8;
use Encode qw(encode);

use GCPlugins::GCfilms::GCfilmsCommon;

{
	package GCPlugins::GCfilms::GCPluginKinopoisk;

	use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

	sub start
	{
		my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
		$self->{inside}->{$tagname}++;
		if ($self->{parsingEnded})
		{
		    return;
		}

		if ($self->{parsingList})
		{
			if ($tagname eq "a")
			{
				if ($attr->{class} eq "all")
				{
					my $url = $attr->{href};
					if ($url =~ m/\/level\/1\/film/)
					{
						$self->{isMovie} = 1;
						$self->{itemIdx}++;
						$self->{itemsList}[$self->{itemIdx}]->{url} = $url;
					}
				}
				if ($attr->{class} eq "orange")
				{
					$self->{isYear} = 1;
				}
			}
			elsif ($tagname eq "title")
			{
			    $self->{insideHTMLtitle} = 1;
			}
		}
		else
		{
			if ($attr->{class} eq "moviename-big" && $attr->{style} eq "margin: 0; padding: 0")
			{
				$self->{insideTitle} = 1;
			}
			elsif ($tagname eq "span")
			{
				if ($attr->{style} eq "color: #666; font-size: 13px")
				{
					$self->{insideOriginal} = 1;
				}
				elsif ($attr->{class} eq "_reachbanner_" && $self->{insideSynopsis} == 0)
				{
					$self->{insideSynopsis} = 1;
				}
			}
			elsif ($tagname eq "a")
			{
				if ($attr->{href} =~ m/\/level\/10\/m\_act\%5Byear\%5D/)
				{
					$self->{insideDate} = 1;
				}
				if ($attr->{href} =~ m/\/level\/10\/m\_act\%5Bcountry\%5D/)
				{
					if ($self->{isCountry} >= 2)
					{
						$self->{insideCountry} = 1;
						$self->{isCountry}++;
					}
				}
				if ($attr->{href} =~ m/\/level\/4\/people/)
				{
					if ($self->{isDirector} >= 2)
					{
						$self->{insideDirector} = 1;
						$self->{isDirector}++;
					}
				}
				if ($attr->{href} =~ m/\/level\/10\/m\_act\%5Bgenre\%5D/)
				{
					$self->{insideGenre} = 1;
					$self->{isGenre}++;
				}
				if ($self->{insideActorList})
				{
					$self->{isActors} += 1;
					$self->{insideActors} = 1;
				}
			}
			elsif ($tagname eq "td")
			{
				if ($attr->{class} eq "type")
				{
					$self->{isDirector} = 1;
					$self->{isTime} = 1;
					$self->{isCountry} = 1;
				}
				elsif ($self->{isTime} == 2)
				{
					$self->{insideTime} = 1;
					$self->{isTime} = 0;
				}
				elsif ($attr->{style} eq "vertical-align: top; height: 15px" && $attr->{align} eq "right" && $self->{isActors} >= 0)
				{
					$self->{isActors} += 1;
					$self->{insideActors} = 1;
				}
			}
			elsif ($tagname eq "img" && $attr->{style} eq "border: none; border-left: 10px #f60 solid")
			{
				if ($attr->{src} ne "/images/image_none.gif")
				{
					$self->{curInfo}->{image} = "http://www.kinopoisk.ru".$attr->{src};
				}
			}
		}
	}

	sub text
	{
		my ($self, $origtext) = @_;
		return if ($self->{parsingEnded});
		if ($self->{parsingList})
		{
			if (($self->{insideHTMLtitle}))
			{
				if ($origtext =~ m/Результаты\sпоиска/)
				{
					#
				}
				else
				{
					$self->{parsingEnded} = 1;
					$self->{itemIdx} = 0;
					$self->{itemsList}[0]->{url} = $self->{loadedUrl};
				}
				$self->{insideHTMLtitle} = 0;
			}
			if ($self->{isMovie})
			{
				my ($title, $date);
				$self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
				$self->{isMovie} = 0;
				return;
			}
			elsif ($self->{isYear})
			{
				$self->{itemsList}[$self->{itemIdx}]->{date} = $origtext;
				$self->{isYear} = 0;
				return;
			}
		}
		else
		{
			if ($origtext =~ m/В\s*главных\s*ролях:/)
			{
				$self->{insideActorList} = 1;
			}
			if ($origtext =~ m/Роли\s*дублировали:/)
			{
				$self->{insideActorList} = 0;
			}
			if ($self->{insideTitle})
			{
				$origtext =~ s/\s+$//;
				$self->{curInfo}->{title} = $origtext;
				$self->{insideTitle} = 0;
			}
			elsif ($self->{insideOriginal})
			{
				$origtext =~ s/^\s+//;
				$self->{curInfo}->{original} = $origtext;
				$self->{insideOriginal} = 0;
			}
			elsif ($self->{insideDate})
			{
				$self->{curInfo}->{date} = $origtext;
				$self->{insideDate} = 0;
			}
			elsif ($self->{insideCountry} == 1)
			{
				if ($self->{isCountry} == 3)
				{
					$self->{curInfo}->{country} = $origtext;
				}
				elsif ($self->{isCountry} > 3)
				{
					$self->{curInfo}->{country} = $self->{curInfo}->{country}.", ".$origtext;
				}
				$self->{insideCountry} = 0;
			}
			elsif ($self->{insideDirector})
			{
				if ($self->{isDirector} == 3)
				{
					$self->{curInfo}->{director} = $origtext;
				}
				elsif ($self->{isDirector} > 3)
				{
					$self->{curInfo}->{director} = $self->{curInfo}->{director}.", ".$origtext;
				}
				$self->{insideDirector} = 0;
			}
			elsif ($self->{insideActors})
			{
				if ($self->{isActors} == 1)
				{
					$self->{curInfo}->{actors} = $origtext;
				}
				elsif ($self->{isActors} > 1)
				{
					if ($origtext eq "...")
					{
						$self->{isActors} = -1;
					}
					else
					{
						$self->{curInfo}->{actors} = $self->{curInfo}->{actors}.", ".$origtext;
					}
				}
				$self->{insideActors} = 0;
			}
			elsif ($self->{insideSynopsis} == 1)
			{
				#$origtext =~ s/^\s+//;
				$self->{curInfo}->{synopsis} = $origtext;
				$self->{insideSynopsis} = 2;
			}
			elsif ($self->{isTime} == 1 || $self->{isDirector} == 1 || $self->{isCountry} == 1)
			{
				$self->{isDirector} = 0;
				$self->{isTime} = 0;
				$self->{isCountry} = 0;
				if ($origtext eq "время")
				{
					$self->{isTime} = 2;
				}
				elsif ($origtext eq "режиссер")
				{
					$self->{isDirector} = 2;
				}
				elsif ($origtext eq "страна")
				{
					$self->{isCountry} = 2;
				}
			}
			elsif ($self->{insideTime})
			{
				$self->{curInfo}->{time} = $origtext;
				$self->{insideTime} = 0;
			}
			elsif ($self->{insideGenre})
			{
				if ($self->{isGenre} == 1)
				{
					$self->{curInfo}->{genre} = $origtext;
				}
				elsif ($self->{isGenre} > 1)
				{
					$self->{curInfo}->{genre} = $self->{curInfo}->{genre}.", ".$origtext;
				}
				$self->{insideGenre} = 0;
			}
		}
	}

	sub end
	{
		my ($self, $tagname) = @_;
		$self->{inside}->{$tagname}--;
		if ($self->{parsingList})
		{
			# Your code for processing search results here
		}
		else
		{
			if ($tagname eq "tr" && $self->{isDirector} >= 2)
			{
				$self->{isDirector} = 0;
			}
			elsif ($tagname eq "tr" && $self->{isGenre} != 0)
			{
				$self->{isGenre} = 0;
			}
			elsif ($tagname eq "td")
			{
				$self->{insideActorList} = 0;
			}
		}
	}

	sub new
	{
		my $proto = shift;
		my $class = ref($proto) || $proto;
		my $self  = $class->SUPER::new();
		bless ($self, $class);

		$self->{hasField} = {
		title => 1,
		date => 1,
		director => 0,
		actors => 0,
		};

		$self->{isInfo} = 0;
		$self->{isMovie} = 0;
		$self->{isYear} = 0;
		$self->{isDirector} = 0;
		$self->{isActors} = 0;
		$self->{isTime} = 0;
		$self->{isGenre} = 0;
		$self->{isCountry} = 0;
		$self->{curName} = undef;
		$self->{curUrl} = undef;
		$self->{insideActorList} = 0;
		return $self;
	}

	sub getName
	{
		return "Kinopoisk";
	}

	sub getAuthor
	{
		return 'Nazarov Pavel';
	}

	sub getLang
	{
		return 'RU';
	}

	sub getCharset
	{
		my $self = shift;
		return "windows-1251";
	}

	sub getSearchCharset
	{
		my $self = shift;
		return "windows-1251";
	}

	sub getSearchUrl
	{
		my ($self, $word) = @_;
		return "http://www.kinopoisk.ru/index.php?kp_query=$word";
	}

	sub getItemUrl
	{
		my ($self, $url) = @_;
		return $url if $url =~ /^http:/;
		return "http://www.kinopoisk.ru/" . $url;
	}

	sub preProcess
	{
		my ($self, $html) = @_;

		$self->{parsingEnded} = 0;

		$html =~ s/&#133;/\.\.\./g;
		$html =~ s/\x92/'/g;
		$html =~ s/\x93/“/g;
		$html =~ s/\x94/”/g;
		$html =~ s/&#151;/—/g;
		$html =~ s/"&#34;/'"/g;
		$html =~ s/&#34;"/"'/g;
		$html =~ s|</a></b><br>|</a><br>|;
		$html =~ s/<br><br>/\x0A/g;
		return $html;
	}
}

1;
