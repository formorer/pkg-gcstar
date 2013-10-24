package GCPlugins::GCfilms::GCAmazonDE;

###################################################
#
#  Copyright 2005-2010 Christian Jodar
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
    package GCPlugins::GCfilms::GCPluginAmazonDE;

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
            if ($tagname eq 'input')
            {
                $self->{beginParsing} = 1
                    if $attr->{src} =~ /go-button-search/;
            }
            return if ! $self->{beginParsing};
            return if ! $self->{beginParsing};
            if ($tagname eq 'srtitle')
            {
                $self->{isTitle} = 1;
            }
            elsif ($tagname eq 'publication')
            {
                $self->{isPublication} = 1;
            }
            elsif ($tagname eq 'actors')
            {
                $self->{isActors} = 1;
            }            
            if ($tagname eq 'a')
            {
                my $urlId;
                if ($urlId = $self->isItemUrl($attr->{href}))
                {
                    $self->{isTitle} = 2 if $self->{isTitle} eq '1';
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
            if (($tagname eq "img") && (!$self->{curInfo}->{image}))
            {
                $self->{curInfo}->{image} = $self->extractImage($attr);
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'content'))
            {
                $self->{insideContent} = 1;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'productDescriptionWrapper'))
            {
                $self->{insideSynopsis} = 1
                    if (!$self->{curInfo}->{synopsis});
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'emptyClear'))
            {
                $self->{insideSynopsis} = 0;
            }
            elsif ($tagname eq "span")
            {
            	$self->{insideNameAndDate} = 1 if $attr->{id} eq "btAsinTitle";
            }
        }
    }

    sub end
    {
		my ($self, $tagname) = @_;

        $self->{inside}->{$tagname}--;
        if ($tagname eq "li")
        {
            $self->{insideActors} = 0;
            $self->{insideDirector} = 0;
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
            if ($self->{isTitle})
            {
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                $self->{isTitle} = 0;
                return;
            }
            elsif ($self->{isPublication})
            {
                $origtext =~ m/([0-9]{4})/;
                $self->{itemsList}[$self->{itemIdx}]->{date} = $1;
                $self->{isPublication} = 0;
                return;
            }
            elsif ($self->{isActors})
            {
                $origtext =~ s/^\s*//;
                $origtext =~ s/\s*$//;
                $self->{itemsList}[$self->{itemIdx}]->{actors} = $origtext
                    if ! $self->{itemsList}[$self->{itemIdx}]->{actors};
                $self->{isActors} = 0;
                return;
            }
        }
       	else
        {
            $origtext =~ s/\s{2,}//g;
            if ($self->{insideNameAndDate})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{insideNameAndDate} = 0;
            }
            elsif (($self->{insideActors}) && ($origtext !~ /^,/))
            {
                $origtext =~ s/^\s//;
                $origtext =~ s/\s+,/,/;
                if ($self->{actorsCounter} < $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS)
                {
                    push @{$self->{curInfo}->{actors}}, [$origtext];
                    $self->{actorsCounter}++;
                }
            }
            elsif (($self->{insideDirector}) && ($origtext !~ /^,/))
            {
                $origtext =~ s/^\s//;
                $origtext =~ s/,.$//;
                $self->{curInfo}->{director} .= ", "
                    if $self->{curInfo}->{director};
                $self->{curInfo}->{director} .= $origtext;
            }
            elsif ($self->{insideTime})
            {
                $origtext =~ s/^\s//;
                $origtext =~ s/\n//g;
                $self->{curInfo}->{time} = $origtext;
                $self->{insideTime} = 0;
            }
            elsif ($self->{insideDate})
            {
                $origtext =~ s/^\s//;
                $origtext =~ s/\n//g;
                $origtext =~ s/\-$//;
                $self->{curInfo}->{date} = $origtext;
                $self->{insideDate} = 0;
            }
            elsif (($self->{insideSynopsis}) && ($origtext ne ''))
            {
                $self->{curInfo}->{synopsis} .= $origtext;
            }
            elsif ($self->{insideAudio})
            {
                $origtext =~ s/^\s//;
                $self->{curInfo}->{audio} = $origtext;
                $self->{insideAudio} = 0;
            }
            elsif ($self->{insideSubTitle})
            {
                $origtext =~ s/^\s//;
                $self->{curInfo}->{subt} = $origtext;
                $self->{insideSubTitle} = 0;
            }
            elsif ($self->{inside}->{b})
            {
                $self->{insideActors} = 1 if $origtext =~ /Darsteller:/;
                $self->{insideDirector} = 1 if $origtext =~ /Regisseur\(e\):/;
                $self->{insideDate} = 1 if $origtext =~ /Erscheinungstermin:/;
                $self->{insideTime} = 1 if $origtext =~ /Spieldauer:/;
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
            actors => 1,
        };

        $self->{suffix} = 'de';

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
            $html =~ s|~(.*?)<span class="bindingBlock">\(<span class="binding">(.*?)</span>( - .*?[0-9]{4})?\)</span>|<actors>$1</actors><format>$2</format><publication>$3</publication>|gsm;

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
            #"
            $html =~ s/<a href="\/exec\/obidos\/search-handle-url\/index=dvd-de&field-(?:actor|director|keywords)=[^\/]*\/[-0-9]*">([^<]*)<\/a>/$1/gm;
        }

        $self->{parsingEnded} = 0;
        $self->{alreadyRetrieved} = {};
        $self->{beginParsing} = 1;

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
