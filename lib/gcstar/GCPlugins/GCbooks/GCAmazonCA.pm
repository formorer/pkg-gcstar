﻿package GCPlugins::GCbooks::GCAmazonCA;

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
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###################################################

use strict;
use utf8;

use GCPlugins::GCbooks::GCbooksAmazonCommon;

{
    package GCPlugins::GCbooks::GCPluginAmazonCA;

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
            if ($tagname eq 'srtitle')
            {
                $self->{isTitle} = 1;
            }
            elsif ($tagname eq 'format')
            {
                $self->{isFormat} = 1 ;
            }
            elsif ($tagname eq 'publication')
            {
                $self->{isPublication} = 1;
            }
            elsif ($tagname eq 'a')
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
            if (($tagname eq "img") && (!$self->{curInfo}->{cover}))
            {
                $self->{curInfo}->{cover} = $self->extractImage($attr);
                $self->{curInfo}->{title} = $attr->{alt};
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'content'))
            {
                $self->{insideContent} = 1;
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;
        $self->{inside}->{$tagname}--;
        $self->{insideContent} = $self->{otherEditions} = 0 if $tagname eq 'div';
        $self->{isAuthor} = $self->{nextIsAuthor} eq 1 if $tagname eq 'a';  
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if GCPlugins::GCstar::GCPluginAmazonCommon::text(@_);
        return if ($self->{parsingEnded});

        if ($self->{parsingList})
        {
            if (($self->{inside}->{title})
             && ($origtext !~ /^Amazon.ca.*/))
            {
                $self->{parsingEnded} = 1;
            }

            return if ! $self->{beginParsing};
            if ($self->{isTitle})
            {
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                $self->{isTitle} = 0;
                $self->{nextIsAuthor} = 1;
                return;
            }
            elsif ($self->{isAuthor})
            {
                $origtext =~ s/^\s*//;
                $origtext =~ s/\s*$//;    
                $origtext =~ s/by //;
                $self->{itemsList}[$self->{itemIdx}]->{authors} = $origtext
                    if ! $self->{itemsList}[$self->{itemIdx}]->{authors};
                $self->{nextIsAuthor} = 0;
                $self->{isAuthor} = 0;
            }
            elsif ($self->{isPublication})
            {
                $self->{itemsList}[$self->{itemIdx}]->{publication} = $origtext;
                $self->{isPublication} = 0;
            }
            elsif ($self->{isFormat})
            {
                $self->{itemsList}[$self->{itemIdx}]->{format} = $origtext;
                $self->{isFormat} = 0;
            }
        }
       	else
        {
            $origtext =~ s/^\s*//;
            $origtext =~ s/\s*$//;
            if ($self->{inside}->{title})
            {
                $origtext =~ m/(.*?):\s*Amazon.ca\s*:\s*([^:]*)(:\s*Books)?\s*$/;
                $self->{curInfo}->{title} = $1;
                $self->{curInfo}->{authors} = $2;
            }
            elsif ($self->{insideDesc})
            {
                $self->{curInfo}->{description} = $origtext
                    if length($origtext) > 7;
                $self->{insideDesc} = 0 if $origtext;
            }
            elsif ($self->{insidePublisher})
            {
                if ($origtext =~ /^\s*(.*?)\(([^(]*?)\)$/)
                {
                    $self->{curInfo}->{publication} = $2;
                    my @array = split /;\s*/, $1;
                    $self->{curInfo}->{publisher} = $array[0];
                    $self->{curInfo}->{edition} = $array[1];
                    $self->{insidePublisher} = 0;
                    $self->{curInfo}->{publication} =~ s|([A-Za-z]*) ([0-9]*) ([0-9]*)|$2.'/'.$self->{monthNumber}->{$1}.'/'.$3|e;
                }
                else
                {
                    ($self->{curInfo}->{publisher} = $origtext) =~ s/;\s*$//;
                }
                $self->{insidePublisher} = 0;
            }
            elsif ($self->{insideLanguage})
            {
                $self->{curInfo}->{language} = $origtext;
                $self->{insideLanguage} = 0;
            }
            elsif ($self->{insideIsbn10})
            {
                $self->{curInfo}->{isbn} = $origtext unless $self->{haveIsbn13};
                $self->{insideIsbn10} = 0;
            }
            elsif ($self->{insideIsbn13})
            {
                $self->{curInfo}->{isbn} = $origtext;
                $self->{insideIsbn13} = 0;
                $self->{haveIsbn13} = 1;
            }
            elsif ($self->{insideSerie})
            {
                $self->{curInfo}->{serie} = $origtext;
                $self->{insideSerie} = 0;
            }
            elsif ($self->{insidePages})
            {
                $self->{curInfo}->{pages} = $origtext;
                $self->{insidePages} = 0;
            }
            elsif ($self->{insideSeries})
            {
                $self->{curInfo}->{serie} = $origtext;
                $self->{insideSeries} = 0;
            }
            elsif ($origtext eq "in")
            {
                $self->{insideSeries} = 1;
            }            
            elsif ($origtext eq 'Product Details')
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
                $self->{insideDesc} = 1 if ($origtext eq 'Book Description' 
                                        || $origtext =~ /^Amazon.com(?! (Sales|Delivers|Home))/)
                                        && ($self->{insideContent});
                $self->{insidePublisher} = 1 if $origtext =~ /Publisher:/;
				$self->{insideLanguage} = 1 if $origtext =~ /Language:/;
                $self->{insideIsbn10} = 1 if $origtext =~ /ISBN(-10)?:/;
                $self->{insideIsbn13} = 1 if $origtext =~ /ISBN-13:/;
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

    sub normalizeMonth
    {
        my ($self, $value) = @_;
        # Lower case and remove special characters
        $value = lc $value;
        $value =~ s/[^a-z]/e/gi;
        return $value;
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{monthNumber} = {
            'Jan' => '01',
            'janvier' => '01',
            'Feb' => '02',
            'fev' => '02',
            'fevrier' => '02',
            'Mar' => '03',
            'mars' => '03',
            'Apr' => '04',
            'avr' => '04',
            'avril' => '04',
            'May' => '05',
            'mai' => '05',
            'jui' => '06',
            'Jun' => '06',
            'juin' => '06',
            'Jul' => '07',
            'juil' => '07',
            'juillet' => '07',
            'Aug' => '08',
            'aoe' => '08',         # Not a typo. All special characters
            'aoet' => '08',        # are replaced with an e.
            'Sep' => '09',
            'septembre' => '09',
            'Oct' => '10',
            'octobre' => '10',
            'Nov' => '11',
            'novembre' => '11',
            'Dec' => '12',
            'decembre' => '12'
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
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isFormat} = 0;

        $self->{suffix} = 'ca';

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $html = $self->SUPER::preProcess($html);
        $html =~ s/&nbsp;/ /gi;
        $html =~ s/&#146;/'/gm;
        $html =~ s/&#133;/.../gm;
        $html =~ s/&#156;/oe/gm;
        $html =~ s|&#x92;|'|gi;
        $html =~ s|&#149;|*|gi;
        $html =~ s|&#133;|...|gi;
        $html =~ s|&#x85;|...|gi;
        $html =~ s|&#x8C;|OE|gi;
        $html =~ s|&#x9C;|oe|gi;

        $self->{parsingEnded} = 0;
        if ($self->{parsingList})
        {
            $self->{otherEditions} = 0;
            $html =~ s|<span class="binding">(.*?)</span> - (.*?[0-9]{4})\)</span>|<format>$1</format><publication>$2</publication>|gsm;
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
            $self->{insideDesc} = 0;
            $self->{insidePublisher} = 0;
            $self->{insideLanguage} = 0;
            $self->{insideSerie} = 0;
            $self->{insideDetails} = 0;
            $self->{insideIsbn10} = 0;
            $self->{insideIsbn13} = 0;
        }
        
        $self->{alreadyRetrieved} = {};
        $self->{beginParsing} = 0;
        return $html;
    }
    
    sub getName
    {
        return 'Amazon (CA)';
    }
    
    sub getAuthor
    {
        return 'TPF';
    }

    sub getLang
    {
        return 'EN';
    }

}

1;