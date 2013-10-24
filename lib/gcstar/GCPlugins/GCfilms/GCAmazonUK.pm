package GCPlugins::GCfilms::GCAmazonUK;

###################################################
#
#  Copyright 2005-2010 Christian Jodar
#  Edited 2009 by FiXx
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
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
#
###################################################

use strict;

use GCPlugins::GCfilms::GCfilmsAmazonCommon;

{
    package GCPlugins::GCfilms::GCPluginAmazonUK;

    use base qw(GCPlugins::GCfilms::GCfilmsAmazonPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

	if ($self->{parsingEnded})
        {
            if ($self->{itemIdx} < 0)
            {
                $self->{itemIdx} = 0;
                $self->{itemsList}[0]->{url} = $self->{loadedUrl};
            }
            return;
        }

        if ($self->{parsingList})
        {
            if (($self->{beginParsing} eq 0) && ($tagname eq 'div') && ($attr->{id} eq 'Results'))
            {
                $self->{beginParsing} = 1;
            }
            if (($self->{beginParsing}) && ($tagname eq 'table') && ($attr->{class} eq 'pagnTable'))
            {
                $self->{beginParsing} = 0;
                $self->{parsingEnded} = 1;
            }
            return if ! $self->{beginParsing};
            if ($tagname eq 'a')
            {
                if (($self->{isItem}) && ($self->{isUrl}))
                {
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                    $self->{isUrl} = 0 ;
                }
            }
            elsif (($tagname eq 'td') && ($attr->{class} eq 'dataColumn'))
            {
                $self->{isItem} = 1 ;
                $self->{isUrl} = 1 ;
                $self->{isName} = 1 ;
            }
        }
        else
        {
            if ($tagname eq "img")
            {
                if (!$self->{curInfo}->{image})
                {
                    $self->{curInfo}->{image} = $self->extractImage($attr);
                }
            }
            elsif ($tagname eq "span")
            {
            	$self->{insideNameAndDate} = 1 if $attr->{id} eq "btAsinTitle";
            }
            elsif (($tagname eq "div") && ($attr->{class} eq "productDescriptionWrapper"))
            {
            	$self->{isSynopsis} = 1;
            }
        }
    }

    sub end
    {
		my ($self, $tagname) = @_;

        $self->{inside}->{$tagname}--;

	if (($tagname eq 'li') && ($self->{insideActors}))
	{
            $self->{insideActors} = 0;
	}

    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if GCPlugins::GCstar::GCPluginAmazonCommon::text(@_);
        return if length($origtext) < 2;
        return if ($self->{parsingEnded});

        if ($self->{parsingList})
        {
            return if ! $self->{beginParsing};
            if ($self->{isName})
            {
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                $self->{isName} = 0;
                $self->{isItem} = 0;
                $self->{inActors} = 1;
            }
            elsif ($self->{inActors} && $self->{inside}->{td})
            {
                $origtext =~ s/^\W*//;
                $self->{itemsList}[$self->{itemIdx}]->{actors} = $origtext
                    if ! $self->{itemsList}[$self->{itemIdx}]->{actors};
                $self->{inActors} = 0;
                return;
            }
        }
       	else
        {
            $origtext =~ s/\s{2,}//g;

            if ($self->{insideNameAndDate})
            {
		(my $year = $origtext) =~ s/.*\[([0-9]{4})\].*/$1/ ;
		(my $title = $origtext) =~ s/^([^\[]*).*$/$1/ ;
                $self->{curInfo}->{title} = $title;
                $self->{curInfo}->{origtitle} = $title;
                $self->{curInfo}->{date} = $year;
                $self->{insideNameAndDate} = 0;
            }
            elsif (($self->{insideActors}) && $self->{inside}->{a})
            {
                $origtext =~ s/^\s//;
                $origtext =~ s/,.$//;
                $self->{curInfo}->{actors} .= $origtext.', ';
            }
            elsif ($self->{insideAge})
            {
                $origtext =~ m/([0-9]{1,2})/;
                $self->{curInfo}->{age} = $1;
                $self->{insideAge} = 0;
            }
            elsif ($self->{insideDirector})
            {
                $origtext =~ s/^\s//;
                $origtext =~ s/,.$//;
                $self->{curInfo}->{director} = $origtext;
                $self->{insideDirector} = 0;
            }
            elsif ($self->{insideTime})
            {
                $origtext =~ s/^\s//;
                $origtext =~ s/\n//g;
                $self->{curInfo}->{time} = $origtext;
                $self->{insideTime} = 0;
            }
            elsif ($self->{isSynopsis})
            {
                $self->{curInfo}->{synopsis} = $origtext if ! $self->{hasSynopsis};
                $self->{isSynopsis} = 0;
		$self->{hasSynopsis} = 1;
            }
            elsif ($self->{inside}->{b})
            {
                $self->{insideActors} = 1 if $origtext =~ /Actors:/;
                $self->{insideDirector} = 1 if $origtext =~ /Directors:/;
                $self->{insideAge} = 1 if $origtext =~ /Classification:/;
                $self->{insideTime} = 1 if $origtext =~ /Run Time:/;
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
            date => 0,
            director => 0,
            actors => 1,
        };

        $self->{suffix} = 'co.uk';

        $self->{curName} = undef;
        $self->{curUrl} = undef;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        $html = $self->SUPER::preProcess($html);
        if ($self->{parsingList})
        {
            $self->{isItem} = 0;
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
            $html =~ s|<a href="/gp/imdb/[^"]*">(.*?)</a>|$1|gm;
            $html =~ s|<a href="[^"]*search-alias=dvd&field-keywords=[^"]*">(.*?)</a>|$1|gm;

            $html =~ s/<a href="\/exec\/obidos\/search-handle-url\/index=dvd&field-(?:actor|director|keywords)=[^\/]*\/[-0-9]*">([^<]*)<\/a>/$1/gm;
        }

        $self->{parsingEnded} = 0;
        $self->{alreadyRetrieved} = {};
        $self->{beginParsing} = 0;

        return $html;
    }
   
    sub getName
    {
        return "Amazon (UK)";
    }
    
    sub getLang
    {
        return 'EN';
    }

    sub getAuthor
    {
        return 'Tian & FiXx';
    }
    

}

1;
