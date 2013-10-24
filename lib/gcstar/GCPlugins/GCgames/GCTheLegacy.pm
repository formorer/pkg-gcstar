package GCPlugins::GCgames::GCTheLegacy;

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
use utf8;

use GCPlugins::GCgames::GCgamesCommon;

{
    package GCPlugins::GCgames::GCPluginTheLegacy;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;
        if ($self->{parsingList})
        {
            if (($tagname eq 'a') && ( $attr->{class} eq 'aa' ))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.thelegacy.de/Museum/" . $attr->{href};
                $self->{isName} = 1 ;
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {
            if (($tagname eq 'div') && ($attr->{style} eq 'font-size:14pt; color:#990000; padding-top:0.5em;'))
            {
                $self->{isName} = 1 ;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'description') && ($self->{curInfo}->{platform} eq ''))
            {
                $self->{isPlatform} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{target} eq 'ListGames') && ($attr->{class} eq 'a') && ($attr->{style} eq ''))
            {
                $self->{isGenre} = 1 ;
            }
            elsif (($tagname eq 'img') && ($attr->{src} =~ m|/pics/cover/Thumb|i))
            {
                $self->{curInfo}->{boxpic} = "http://www.thelegacy.de" . $attr->{src};
            }
            elsif (($tagname eq 'img') && ($attr->{src} =~ m|/pics/backcover/Thumb|i))
            {
                $self->{curInfo}->{backpic} = "http://www.thelegacy.de" . $attr->{src};
            }
            elsif (($tagname eq 'img') && ($attr->{src} =~ m|/pics/screen|i))
            {
                if ($self->{curInfo}->{screenshot1} eq '')
                {
                    $self->{curInfo}->{screenshot1} = "http://www.thelegacy.de" . $attr->{src};
                }
                elsif ($self->{curInfo}->{screenshot2} eq '')
                {
                    $self->{curInfo}->{screenshot2} = "http://www.thelegacy.de" . $attr->{src};
                }
            }
            elsif ( (($tagname eq 'span') ||($tagname eq 'div')) && ($attr->{class} eq 'category'))
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($self->{isEditor} eq 1) && ($tagname eq 'a') && ($attr->{target} eq 'ListGames') && ($attr->{class} eq 'aa') && ($self->{curInfo}->{editor} eq ''))
            {
                $self->{isEditor} = 2 ;
            }
            elsif (($self->{isDeveloper} eq 1) && ($tagname eq 'a') && ($attr->{target} eq 'ListGames') && ($attr->{class} eq 'aa') && ($self->{curInfo}->{developer} eq ''))
            {
                $self->{isDeveloper} = 2 ;
            }
            elsif (($self->{isDate} eq 1) && ($tagname eq 'div') && ($attr->{class} eq 'description') && ($self->{curInfo}->{released} eq ''))
            {
                $self->{isDate} = 2 ;
            }
            elsif (($tagname eq 'a') && ($attr->{name} =~ m|review_|i))
            {
                $self->{isDescription} = 1 ;
            }
            elsif (($self->{isDescription} eq 1) && ($tagname eq 'a') && ($attr->{class} eq 'aa'))
            {
                $self->{isDescription} = 2 ;
            }
            elsif (($tagname eq 'span') && ( $attr->{id} =~ m|review_|i) && ( $attr->{id} =~ m|_less|i))
            {
                $self->{isDescription} = 0 ;
            }
        }
    }

    sub end
    {
	my ($self, $tagname) = @_;
		
        $self->{inside}->{$tagname}--;
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//;
            if ($self->{isName})
            {
                $self->{itemsList}[$self->{itemIdx}]->{name} = $origtext;
                $self->{isName} = 0;
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//;
            if ($self->{isName})
            {
                $self->{curInfo}->{name} = $origtext;
                $self->{isName} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isDate} = 0;
                $self->{isDeveloper} = 0;
                $self->{isEditor} = 0;

                $self->{isDate} = 1 if ($origtext =~ m/ffentlichung/i);
                $self->{isDate} = 1 if ($origtext =~ m/Publishing/i);
                $self->{isDeveloper} = 1 if ($origtext =~ m/Entwickler/i);
                $self->{isDeveloper} = 1 if ($origtext =~ m/developer/i);
                $self->{isEditor} = 1 if ($origtext =~ m/Publisher/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isDate} eq 2)
            {
                $origtext =~ s/://;
                $self->{curInfo}->{released} = $origtext;
                $self->{isDate} = 0 ;
            }
            elsif ($self->{isGenre})
            {
                $self->{curInfo}->{genre} .= $origtext;
                $self->{curInfo}->{genre} .= ",";
                $self->{isGenre} = 0;
            }
            elsif ($self->{isDeveloper} eq 2)
            {
                $self->{curInfo}->{developer} = $origtext;
                $self->{isDeveloper} = 0 ;
            }
            elsif ($self->{isEditor} eq 2)
            {
                $self->{curInfo}->{editor} = $origtext;
                $self->{isEditor} = 0 ;
            }
            elsif ($self->{isPlatform})
            {
                $origtext =~ s/PC \(Windows\)/PC/;
                my @array = split(/-/,$origtext);
                $self->{curInfo}->{platform} = $array[0];
                # Enleve les blancs en fin de chaine
                $self->{curInfo}->{platform} =~ s/\s+$//;
                $self->{isPlatform} = 0;
            }
            elsif ($self->{isDescription} eq 1)
            {
                $self->{curInfo}->{description} .= $origtext;
            }
            elsif ($self->{isDescription} eq 2)
            {
                $self->{isDescription} = 1;
            }
        }
    } 

    sub getTipsUrl
    {
        my $self = shift;
        
        return ;
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            name => 1,
            platform => 0,
            genre => 0,
            released => 0
        };

        $self->{isInfo} = 0;
        $self->{isName} = 0;
        $self->{isPlatform} = 0 ;
        $self->{isAnalyse} = 0;
        $self->{isEditor} = 0;
        $self->{isDeveloper} = 0;
        $self->{isDate} = 0;
        $self->{isGenre} = 0;
        $self->{isDescription} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
        }
        else
        {
            $html =~ s|<u>||gi;
            $html =~ s|<li>|\n* |gi;
            $html =~ s|<br>|\n|gi;
            $html =~ s|<br />|\n|gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<i>||gi;
            $html =~ s|</i>||gi;
            $html =~ s|<p>|\n|gi;
            $html =~ s|</p>||gi;
            $html =~ s|\x{92}|'|gi;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
            $html =~ s|&#156;|oe|gi;
            $html =~ s|&#133;|...|gi;
            $html =~ s|\x{85}|...|gi;
            $html =~ s|\x{8C}|OE|gi;
            $html =~ s|\x{9C}|oe|gi;
        }
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;

        return "http://www.thelegacy.de/Museum/SQLlist_games.php3?logicalSearchConnection[]=AND&SearchValue=" . $word. "&searchEntity=TITLE&Review=&Forum=&type=&changed=&TopTen=&titel_id=&game_id=&titel=&first_letter=&misc=yes&quick=yes";
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return $url;
    }

    sub getName
    {
        return 'TheLegacy';
    }
    
    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'DE';
    }

    sub getCharset
    {
        my $self = shift;
    
        return "ISO-8859-15";
    }

    sub getSearchFieldsArray
    {
        return ['name'];
    }
}

1;
