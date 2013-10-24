package GCPlugins::GCgames::GCNextGame;

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
    package GCPlugins::GCgames::GCPluginNextGame;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($self->{isGenre} eq '1')
            {
                $self->{isGenre} = 2 ;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'box_searchresult'))
            {
                $self->{isGame} = 1 ;
                $self->{itemIdx}++;
            }
            elsif (($tagname eq 'ul') && ($attr->{class} eq 'platforms'))
            {
                $self->{isPlatform} = 1 ;
            }
            elsif (($tagname eq 'li') && ($self->{isPlatform} eq 1))
            {
                $self->{isPlatform} = 2 ;
            }
            elsif (($tagname eq 'hr') && ($attr->{class} eq 'clear'))
            {
                $self->{isPlatform} = 0 ;
            }
            elsif (($tagname eq 'a') && ($attr->{class} eq 'blu'))
            {
                return if $self->{alreadyRetrieved}->{$attr->{href}};
                $self->{alreadyRetrieved}->{$attr->{href}} = 1;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                $self->{isName} = 1 ;
            }
            elsif (($tagname eq 'dt') && ($self->{isGame} eq '1'))
            {
                $self->{isAnalyse} = 1 ;
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {

            if ($self->{isDeveloper} eq 1)
            {
                $self->{isDeveloper} = 2;
            }
            elsif ($self->{isGenre} eq 1)
            {
                $self->{isGenre} = 2;
            }
            elsif ($self->{isEditor} eq 1)
            {
                $self->{isEditor} = 2 ;
            }
            elsif ($self->{isDate} eq 1)
            {
                $self->{isDate} = 2 ;
            }
            elsif ($self->{isPlayer} eq 1)
            {
                $self->{isPlayer} = 2;
            }
            elsif ($self->{isPlatform} eq 1)
            {
                $self->{isPlatform} = 2;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'box_liquid'))
            {
                $self->{isDescription} = 0 ;
            }
            elsif ($tagname eq 'head')
            {
                $self->{isDescription} = 0 ;
            }
            elsif (($tagname eq 'h1') && ($attr->{class} eq 'blu'))
            {
                $self->{isName} = 1 ;
            }
            elsif (($tagname eq 'hr') && ($attr->{class} eq 'clear'))
            {
                $self->{isAnalyse} = 0 ;
            }
            elsif (($tagname eq 'dl') && ($attr->{class} eq 'datasheet_column'))
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'dt') && ($self->{isAnalyse} eq '1'))
            {
                $self->{isAnalyse} = 2 ;
            }
            elsif (($tagname eq 'td') && ($attr->{class} eq 'active current'))
            {
                $self->{isPlatform} = 1 ;
            }
            elsif (($tagname eq 'img') && ($attr->{id} eq 'datasheet_packshot'))
            {
                $self->{curInfo}->{boxpic} = $attr->{src};
                if ($self->{bigPics})
                {
                   $self->{curInfo}->{boxpic} =~ s|.T160.|.|gi;
                }
            }
            elsif ( ($tagname eq 'img') && ($attr->{class} eq 'thumb') )
            {
                if ($self->{curInfo}->{screenshot1} eq '')
                {
                    $self->{curInfo}->{screenshot1} = $attr->{src};
                    if ($self->{bigPics})
                    {
                       $self->{curInfo}->{screenshot1} =~ s|.T200.|.|gi;
                    }
                }
                elsif ($self->{curInfo}->{screenshot2} eq '')
                {
                    $self->{curInfo}->{screenshot2} = $attr->{src};
                    if ($self->{bigPics})
                    {
                       $self->{curInfo}->{screenshot2} =~ s|.T200.|.|gi;
                    }
                }
            }
            elsif (($tagname eq 'a') && ($attr->{name} eq 'REVIEW'))
            {
                $self->{isDescription} = 1 ;
            }
            elsif (($tagname eq 'ul') && ($attr->{class} eq 'platforms') && ($self->{isDescription} eq 1))
            {
                $self->{isDescription} = 2 ;
            }
            elsif (($tagname eq 'a') && ($attr->{class} eq 'blu') && ($self->{isDescription} eq 3))
            {
                my $html = $self->loadPage( $attr->{href}, 0, 1 );
                $html =~ s|&amp;|&|gi;
                my $found = index($html,"<div class=\"testo edit_inline_box\" id=\"id_text\">");
                if ( $found >= 0 )
                {
                   $html = "<>" . substr($html, $found +length('<div class="testo edit_inline_box" id="id_text">'),length($html)- $found -length('<div class="testo edit_inline_box" id="id_text">'));

                   $found = index($html,"<div class=\"byline\">");
                   if ( $found >= 0 )
                   {
                      $html = substr($html, 0, $found);
                   }

                   my @array = split(/</,$html);
                   my $element;

                   foreach $element (@array)
                   {
                      $found = index($element,">");
                      if ( $found >= 0 )
                      {
                         $self->{curInfo}->{description} .= substr($element, $found +length('>'),length($element)- $found -length('>'));
                      }
                   }
                }
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
            if ($self->{isName})
            {
                $self->{itemsList}[$self->{itemIdx}]->{name} = $origtext;
                $self->{isName} = 0;
            }
            elsif ($self->{isPlatform} eq 2)
            {
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//;

                if (($self->{itemsList}[$self->{itemIdx}]->{platform} eq '') && ($origtext ne ''))
                {
                   $self->{itemsList}[$self->{itemIdx}]->{platform} = $origtext;
                }
                elsif ($origtext ne '')
                {
                   $self->{itemsList}[$self->{itemIdx}]->{platform} .= ', ';
                   $self->{itemsList}[$self->{itemIdx}]->{platform} .= $origtext;
                }

                $self->{isPlatform} = 1 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isGenre} = 1 if ($origtext =~ m/Genere/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isGenre} eq 2)
            {
                $self->{itemsList}[$self->{itemIdx}]->{genre} = $origtext;

                my @array = split(/,/,$self->{itemsList}[$self->{itemIdx}]->{platform});
                my $element;

                my $SaveName = $self->{itemsList}[$self->{itemIdx}]->{name};
                my $SaveUrl = $self->{itemsList}[$self->{itemIdx}]->{url};
                my $SaveGenre = $self->{itemsList}[$self->{itemIdx}]->{genre};
                $self->{itemIdx}--;

                if ($SaveName ne "")
                {
                   foreach $element (@array)
                   {
                      # Enleve les blancs en debut de chaine
                      $element =~ s/^\s+//;
                      # Enleve les blancs en fin de chaine
                      $element =~ s/\s+$//;

                      $self->{itemIdx}++;
                      $self->{itemsList}[$self->{itemIdx}]->{name} = $SaveName;
                      $self->{itemsList}[$self->{itemIdx}]->{url} = $SaveUrl . $element .'/';
                      $self->{itemsList}[$self->{itemIdx}]->{platform} = $element;
                      $self->{itemsList}[$self->{itemIdx}]->{genre} = $SaveGenre;
                   }
                }
                else
                {
                   $self->{itemIdx}++;
                   delete $self->{itemsList}[$self->{itemIdx}];
                   $self->{itemIdx}--;
                }

                $self->{isGenre} = 0;
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            if ($self->{isName})
            {
                $self->{curInfo}->{name} = $origtext;
                $self->{isName} = 0 ;

                if ($self->{ean} ne '')
                {
                   $self->{curInfo}->{ean} = $self->{ean};
                }

            }
            elsif ($self->{isPlatform} eq 2)
            {
                $self->{curInfo}->{platform} = $origtext;
                $self->{isPlatform} = 0;
            }
            elsif ($self->{isAnalyse} eq 2)
            {
                $self->{isEditor} = 1 if ($origtext =~ m/Produttore/i);
                $self->{isDeveloper} = 1 if ($origtext =~ m/Sviluppatore/i);
                $self->{isGenre} = 1 if ($origtext =~ m/Genere/i);
                $self->{isDate} = 1 if ($origtext =~ m/Disponibile/i);
                $self->{isPlayer} = 1 if ($origtext =~ m/Giocatori/i);

                $self->{isAnalyse} = 1 ;
            }
            elsif ($self->{isDeveloper} eq 2)
            {
                $self->{curInfo}->{developer} = $origtext;
                $self->{isDeveloper} = 0;
            }
            elsif ($self->{isGenre} eq 2)
            {
                $self->{curInfo}->{genre} = $origtext;
                $self->{isGenre} = 0;
            }
            elsif ($self->{isEditor} eq 2)
            {
                $self->{curInfo}->{editor} = $origtext;
                $self->{isEditor} = 0 ;
            }
            elsif ($self->{isDate} eq 2)
            {
                $self->{curInfo}->{released} = $origtext;
                $self->{isDate} = 0 ;
            }
            elsif ($self->{isPlayer} eq 2)
            {
                $self->{curInfo}->{players} = $origtext;
                $self->{isPlayer} = 0 ;
            }
            elsif ($self->{isDescription} eq 2)
            {
                if ($origtext =~ m/$self->{curInfo}->{platform}/i)
                {
                   $self->{isDescription} = 3;
                }
                else
                {
                   $self->{isDescription} = 1;
                }
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
            platform => 1,
            genre => 1,
            released => 0
        };

        $self->{isName} = 0;
        $self->{isGame} = 0;
        $self->{isPlatform} = 0;
        $self->{isAnalyse} = 0 ;
        $self->{isGenre} = 0;
        $self->{isEditor} = 0;
        $self->{isDeveloper} = 0;
        $self->{isDate} = 0;
        $self->{isPlayer} = 0;
        $self->{isDescription} = 0;
        $self->{ean} = '';

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
            $html =~ s|</li><li>|<ul class="platforms">|gi;
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
        $self->{alreadyRetrieved} = {};
        return $html;
    }
    
    sub getSearchUrl
    {
        my ($self, $word) = @_;

        if ($self->{searchField} eq 'ean')
        {
            $self->{ean} = $word;
        }
        else
        {
            $self->{ean} = '';
        }

        return 'http://next.videogame.it/magazine/review/?name='.$word;
    }
    
    sub getItemUrl
    {
	my ($self, $url) = @_;

        return $url if $url;
        return 'http://next.videogame.it/';
    }

    sub getName
    {
        return 'NextGame';
    }
    
    sub getCharset
    {
        my $self = shift;
        return "ISO-8859-1";
    }

    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'IT';
    }

    sub getSearchFieldsArray
    {
        return ['name'];
    }

    sub getDefaultPictureSuffix
    {
        return '.jpg';
    }
}

1;

