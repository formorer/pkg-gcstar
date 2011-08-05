package GCPlugins::GCbooks::GCAmazonDE;

###################################################
#
#  Copyright 2005-2010 Christian Jodar
#
#  Updated 28/02/2010 by palto
#    * fixed issue with retrieving the description texts
#
#  This file is part of GCstar.
#
#  GCstar is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  GCstar is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with GCstar; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###################################################

use strict;

use GCPlugins::GCbooks::GCbooksAmazonCommon;

{
    package GCPlugins::GCbooks::GCPluginAmazonDE;

    use base qw(GCPlugins::GCbooks::GCbooksAmazonPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

	    if ($self->{parsingEnded})
        {
            if ($self->{itemIdx} < 0)
            {
                if ($self->{loadedUrl} !~ m|^http://s1\.amazon|)
                {
                    $self->{itemIdx} = 0;
                    $self->{itemsList}[0]->{url} = $self->{loadedUrl};
                }
                else
                {
                    if (($tagname eq 'a') && ($attr->{href} =~ m|exec/obidos/ASIN| ))
                    {
                        $self->{itemIdx} = 0;
                        $self->{itemsList}[0]->{url} = $attr->{href};
                    }
                }
            }
            return;
        }

        if ($self->{parsingList})
        {
            $self->{otherEditions} = 1 if ($tagname eq 'div') && ($attr->{class} eq 'otherEditions');
            return if $self->{otherEditions};
            if ($tagname eq 'input')
            {
                $self->{beginParsing} = 1
                    if $attr->{src} =~ /go-button-search/;
            }
            return if ! $self->{beginParsing};
            if ($tagname eq 'a')
            {
                my $urlId;
                if ($urlId = $self->isItemUrl($attr->{href}))
#                if (($attr->{href} =~ m|/dp/[A-Z0-9]*/sr=([0-3]-[0-9]*)/qid=[0-9]*|)
#                 || ($attr->{href} =~ m|/dp/[A-Z0-9]*/ref=sr_([0-9_]*)/[0-9]*|))
                 {
                     return if $self->{alreadyRetrieved}->{$urlId};
                     $self->{alreadyRetrieved}->{$urlId} = 1;
                     $self->{currentRetrieved} = $urlId;
                     my $url = $attr->{href}; 
                     $self->{itemIdx}++;
                     $self->{itemsList}[$self->{itemIdx}]->{url} = $url;
                 }
            }
        }
        else
        {
            if (($tagname eq "img") && (!$self->{curInfo}->{cover}))
            {
                $self->{curInfo}->{cover} = $self->extractImage($attr);
            }
# Product Description - new code inserted by palto
			elsif (($tagname eq "div") && ($attr->{class} eq 'productDescriptionWrapper'))
			{
				$self->{insideDesc} = 1;
			}
			elsif (($tagname eq "h3") && ($attr->{class} eq 'productDescriptionSource'))
			{
				$self->{insideDescSource} = 1;
			}
# end of new code from palto
        }
    }

    sub end
    {
		my ($self, $tagname) = @_;
        $self->{inside}->{$tagname}--;
        $self->{insideContent} = $self->{otherEditions} = 0 if $tagname eq 'div';
# Product Description - new code inserted by palto
# Description ends with </div> tag and could be split by other tags like html links.
		if (($tagname eq "div") && ($self->{insideDesc}))
		{
			$self->{insideDesc} = 0;
			$self->{curInfo}->{description} .= "\n\n";
		}
# end of new code from palto
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if GCPlugins::GCstar::GCPluginAmazonCommon::text(@_);
        return if ($self->{parsingEnded});

        if ($self->{parsingList})
        {
            if (($self->{inside}->{title})
            && ($origtext !~ /Amazon.com.*? B.+?cher/)
            && ($origtext !~ /^Amazon.de*/))
            {
                $self->{parsingEnded} = 1;
            }
            
            return if ! $self->{beginParsing};
            if ($self->{inside}->{srtitle})
            {
                return if length($origtext) < 2;
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                return;
            }
            elsif ($self->{inside}->{author})
            {
                $origtext =~ s/von //;
                $self->{itemsList}[$self->{itemIdx}]->{authors} = $origtext
                    if ! $self->{itemsList}[$self->{itemIdx}]->{authors};
            }
            elsif ($self->{inside}->{publication})
            {
                $self->{itemsList}[$self->{itemIdx}]->{publication} = $origtext;
            }
            elsif ($self->{inside}->{format})
            {
                $self->{itemsList}[$self->{itemIdx}]->{format} = $origtext;
            }
        }
       	else
        {
			$origtext =~ s/^\s*//;
            $origtext =~ s/\s*$//;
            if ($self->{inside}->{title})
            {
                $origtext =~ m/(.*?):\s*Amazon.de\s*:\s*([^:]*):\s*(B.+?cher|English Books)\s*$/;
                $self->{curInfo}->{title} = $1;
                $self->{curInfo}->{authors} = $2;
            }
# Code added by palto to insert the description source into the description text (needed to distinguish multiple descritions)
			elsif ($self->{insideDescSource})
            {
                $self->{curInfo}->{description} .= $origtext . ":\n";
				$self->{insideDescSource} = 0;
            }
# Code modified by palto
# Concatenate multiple text sections of the description 
            elsif ($self->{insideDesc})
            {
                $self->{curInfo}->{description} .= $origtext;
#                $self->{insideDesc} = 0;
# Removed here, will be cleared at the end of the <div> tag instead.
# end of modifications from palto
            }
            elsif ($self->{insidePublisher})
            {
                $origtext =~ /^\s*(.*?)\(([^(]*?)\)$/;
                $self->{curInfo}->{publication} = $2;
                my @array = split /;\s*/, $1;
                $self->{curInfo}->{publisher} = $array[0];
                $self->{curInfo}->{edition} = $array[1];
                $self->{insidePublisher} = 0;
                $self->{curInfo}->{publication} =~ s|([0-9]*)\.*\s*(.*)\.*\s+([0-9]*)|($1?$1.'/':'').($2?$self->{monthNumber}->{$2}.'/':'').$3|e;
            }
            elsif ($self->{insideLanguage})
            {
                $self->{curInfo}->{language} = $origtext;
                $self->{insideLanguage} = 0;
            }
            elsif ($self->{insideIsbn})
            {
                $self->{curInfo}->{isbn} = $origtext;
                $self->{insideIsbn} = 0;
            }
            elsif ($self->{insidePages})
            {
                $self->{curInfo}->{pages} = $origtext;
                $self->{insidePages} = 0;
            }        
            elsif ($origtext eq 'Produktinformation')
            {
                $self->{insideDetails} = 1;
            }
            elsif (($origtext eq ">") && !($self->{curInfo}->{genre}))
            {
                $self->{insideGenre} = 1;
            }
            elsif ($self->{insideGenre} eq 1)
            {
                $self->{curInfo}->{genre} = $origtext;
                $self->{insideGenre} = 0;
            }
            elsif ($self->{inside}->{b})
            {
#                $self->{insideDesc} = 1 if $origtext eq 'Kurzbeschreibung' 
#			 	|| $origtext =~ /^Amazon.de/
#   	                                   || $origtext eq 'kulturnews.de';
                $self->{insidePublisher} = 1 if $origtext =~ /Verlag:/;
                $self->{insideLanguage} = 1 if $origtext =~ /Sprache:/;
                $self->{insideIsbn} = 1 if $origtext =~ /ISBN-13:/;
                if ($self->{insideDetails})
                {
                    $origtext =~ s/:$//;
                    $self->{curInfo}->{format} = $origtext;
                    $self->{insidePages} = 1;
                    $self->{insideDetails} = 0;
                }
            }
        }
    } 

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{monthNumber} = {
            'Jan' => '01',
            'Januar' => '01',
            'Feb' => '02', 
            'Februar' => '02',
            'Mär' => '03',
            'März' => '03',
            'Apr' => '04',
            'April' => '04',
            'Mai' => '05',
            'Jun' => '06',
            'Juni' => '06',
            'Jul' => '07',
            'Juli' => '07',
            'Aug' => '08',
            'August' => '08',
            'Sep' => '09',
            'September' => '09',
            'Okt' => '10',
            'Oktober' => '10',
            'Nov' => '11',
            'November' => '11',
            'Dez' => '12',
            'Dezember' => '12'

        };

        $self->{hasField} = {
            title => 1,
            authors => 1,
            publication => 1,
            format => 1,
            edition => 0,
        };

        $self->{curName} = undef;
        $self->{curUrl} = undef;

        $self->{suffix} = 'de';

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $html = $self->SUPER::preProcess($html);
        $html =~ s/&nbsp;/ /gi;
        $html =~ s/&#146;/'/gm;
		$html =~ s/&#150;/-/gm;
		$html =~ s/&#132;/&#187;/gm;
		$html =~ s/&#147;/&#171;/gm;
		HTML::Entities::decode_entities($html);
        $self->{parsingEnded} = 0;
        if ($self->{parsingList})
        {
            $self->{otherEditions} = 0;
            $html =~ s|^\s+von(.*)$|<author>$1</author>|gm;
            $html =~ s|<span class="bindingBlock">\(<span class="binding">(.*?)</span> - (.*?[0-9]{4})\)</span>|<format>$1</format><publication>$2</publication>|gsm;
            $self->{parsingEnded} = 1
                if $html !~ /<title>/;
        }
        else
        {
            $html =~ s/(<i>|<\/i>)//gim;
            $html =~ s/<p>/\n/gim;
            $html =~ s|</p>|\n|gim;
            $html =~ s/(<ul>|<\/ul>)/\n/gim;
            $html =~ s/<li>([^<])/- $1/gim;
            $html =~ s|([^>])</li>|$1\n|gim;
            $html =~ s|<br ?/?>|\n|gi;
            $html =~ s|&#252;|ü|g;
            $html =~ s|&#223;|ß|g;
            $html =~ s|&#246;|ö|g;
            $html =~ s|&#220;|Ü|g;
            $html =~ s|&#228;|ä|g;
            $self->{insideDesc} = 0;
			$self->{insideDescSource} = 0;
            $self->{insidePublisher} = 0;
            $self->{insideLanguage} = 0;
            $self->{insideSerie} = 0;
            $self->{insidePages} = 0;
            $self->{insideIsbn} = 0;
        }
        
        $self->{alreadyRetrieved} = {};
        $self->{beginParsing} = 0;
        return $html;
    }

    sub getName
    {
        return "Amazon (DE)";
    }
    
    sub getLang
    {
        return 'DE';
    }
}

1;
