package GCPlugins::GCgames::GCLudus;

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
    package GCPlugins::GCgames::GCPluginLudus;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;
        if ($self->{parsingList})
        {
            if (($tagname eq 'span') && ( $attr->{class} eq 'titolini' ))
            {
                $self->{isGame} = 1 ;
            }
            elsif (($tagname eq 'img') && ($self->{isGame}))
            {
                $self->{isGame} = 0 ;
                $self->{isInfo} = 0 ;
            }
            elsif (($tagname eq 'a') && ($self->{isGame}))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.ludus.it/" . $attr->{href};
                $self->{isName} = 1 ;
                $self->{isInfo} = 1 ;
            }
            elsif (($tagname eq 'td') && ( $attr->{class} eq 'trat2' ) && ($self->{isInfo} eq '1'))
            {
                # le deuxieme champs est le type de donnees
                $self->{isInfo} = 2 ;
            }
            elsif (($tagname eq 'td') && ( $attr->{class} eq 'trat2' ) && ($self->{isInfo} eq '2'))
            {
                # le troisieme champs est la plateforme
                $self->{isPlatform} = 1 ;
                $self->{isInfo} = 3 ;
            }
            elsif (($tagname eq 'td') && ( $attr->{class} eq 'trat2' ) && ($self->{isInfo} eq '3'))
            {
                # le quatrieme champs est la date de sortie
                $self->{isDate} = 1 ;
                $self->{isInfo} = 0 ;
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {
            if (($tagname eq 'td') && ($attr->{colspan} eq '2') && ($attr->{class} eq 'titoli2'))
            {
                $self->{isName} = 1 ;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'testo4'))
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif ($self->{isPlatform} eq 1)
            {
                $self->{isPlatform} = 2 ;
            }
            elsif ($self->{isEditor} eq 1)
            {
                $self->{isEditor} = 2 ;
            }
            elsif ($self->{isDeveloper} eq 1)
            {
                $self->{isDeveloper} = 2 ;
            }
            elsif ($self->{isGenre} eq 1)
            {
                $self->{isGenre} = 2 ;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'testo') && ($attr->{align} eq ''))
            {
                $self->{isDescription} = 1 ;
            }
            elsif (($tagname eq 'tpfsautdeligne') && ($self->{isDescription}))
            {
                $self->{curInfo}->{description} .= "\n";
            }
            elsif (($tagname eq 'table') && ($self->{isDescription}))
            {
                $self->{isDescription} = 0 ;
            }
            elsif ( ($tagname eq 'a') && (index($attr->{onclick},"adafl=win") >= 0) && ($self->{curInfo}->{screenshot1} eq '') && ($self->{curInfo}->{screenshot2} eq ''))
            {
                $self->{isScreen} = 1;
            }
            elsif ( ($tagname eq 'img') && ($self->{isScreen}) )
            {
                if ($self->{curInfo}->{screenshot1} eq '')
                {
                    $self->{curInfo}->{screenshot1} = $attr->{src};
                    $self->{curInfo}->{screenshot1} =~ s|//|http://www.ludus.it/|;
                    my $found = index(reverse($self->{curInfo}->{screenshot1}),"/");
                    if ( $found >= 0 )
                    {
                       my $tempscreen = substr(reverse($self->{curInfo}->{screenshot1}), $found +length('/'),length($self->{curInfo}->{screenshot1})- $found -length('/'));
                       my $tempscreen2 = substr(reverse($self->{curInfo}->{screenshot1}), 0, $found);
                       $tempscreen2 = "/immagini_grandi/" . reverse($tempscreen2);
                       $self->{curInfo}->{screenshot1} = reverse($tempscreen) . $tempscreen2;
                    }
                }
                elsif ($self->{curInfo}->{screenshot2} eq '')
                {
                    $self->{curInfo}->{screenshot2} = $attr->{src};
                    $self->{curInfo}->{screenshot2} =~ s|//|http://www.ludus.it/|;
                    my $found = index(reverse($self->{curInfo}->{screenshot2}),"/");
                    if ( $found >= 0 )
                    {
                       my $tempscreen = substr(reverse($self->{curInfo}->{screenshot2}), $found +length('/'),length($self->{curInfo}->{screenshot2})- $found -length('/'));
                       my $tempscreen2 = substr(reverse($self->{curInfo}->{screenshot2}), 0, $found);
                       $tempscreen2 = "/immagini_grandi/" . reverse($tempscreen2);
                       $self->{curInfo}->{screenshot2} = reverse($tempscreen) . $tempscreen2;
                    }
                    $self->{isScreen} = 0;
                }
            }
            elsif (($tagname eq 'a') && (index($attr->{href},"post_form") >= 0))
            {
                $self->{curInfo}->{boxpic} = $attr->{href};
                $self->{curInfo}->{boxpic} =~ s|/LINGUA/IT||;
                my $found = index(reverse($self->{curInfo}->{boxpic}),"/");
                if ( $found >= 0 )
                {
                   $self->{curInfo}->{boxpic} = substr(reverse($self->{curInfo}->{boxpic}), 0, $found);
                   $self->{curInfo}->{boxpic} = "http://www.ludus.it/copertine/giochi/" . reverse($self->{curInfo}->{boxpic}) . ".jpg";
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
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//;
            if ($self->{isName})
            {
                $self->{itemsList}[$self->{itemIdx}]->{name} = $origtext;
                $self->{isName} = 0;
            }
            elsif ($self->{isDate})
            {
                $self->{itemsList}[$self->{itemIdx}]->{released} = $origtext;
                $self->{isDate} = 0;
            }
            elsif ($self->{isPlatform})
            {
                $origtext =~ s/Pc/PC/;
                $self->{itemsList}[$self->{itemIdx}]->{platform} = $origtext;
                $self->{isPlatform} = 0;
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
                my $found = index(reverse($origtext),"-");
                if ( $found >= 0 )
                {
                   $origtext = substr(reverse($origtext), $found +length('-'),length($origtext)- $found -length('-'));
                   $origtext = reverse($origtext);
                }
                $self->{curInfo}->{name} = $origtext;
                $self->{curInfo}->{released} = $self->{itemsList}[$self->{wantedIdx}]->{released};
                $self->{isName} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isPlatform} = 1 if ($origtext =~ m/Piattaforma:/i);
                $self->{isEditor} = 1 if ($origtext =~ m/Software House:/i);
                $self->{isDeveloper} = 1 if ($origtext =~ m/Sviluppatore:/i);
                $self->{isGenre} = 1 if ($origtext =~ m/Genere:/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isGenre} eq 2)
            {
                my @array = split(/\//,$origtext);
                my $element;
                foreach $element (@array)
                {
                   # Enleve les blancs en debut de chaine
                   $element =~ s/^\s+//;
                   $self->{curInfo}->{genre} .= $element;
                   $self->{curInfo}->{genre} .= ",";
                }
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
            elsif ($self->{isPlatform} eq 2)
            {
                $origtext =~ s/Pc/PC/;
                $self->{curInfo}->{platform} = $origtext;
                $self->{isPlatform} = 0;
            }
            elsif ($self->{isDescription})
            {
                $self->{curInfo}->{description} .= $origtext;
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
            genre => 0,
            released => 1
        };

        $self->{isInfo} = 0;
        $self->{isName} = 0;
        $self->{isGame} = 0;
        $self->{isPlatform} = 0 ;
        $self->{isAnalyse} = 0;
        $self->{isEditor} = 0;
        $self->{isDeveloper} = 0;
        $self->{isDate} = 0;
        $self->{isGenre} = 0;
        $self->{isScreen} = 0;

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
            $html =~ s|<br>|<tpfsautdeligne>|gi;
            $html =~ s|<br />|<tpfsautdeligne>|gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<i>||gi;
            $html =~ s|</i>||gi;
            $html =~ s|<p>|\n|gi;
            $html =~ s|</p>||gi;
            $html =~ s|\x{92}|'|gi;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
        }
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;

        $word =~ s/\+/ /g;
        return ('http://www.ludus.it/code/lista_alfabetica_giochi/LINGUA/IT', ["categoria" => "2", "SEARCH_STRING" => "$word"] );
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return $url;
    }

    sub getName
    {
        return 'Ludus';
    }
    
    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'IT';
    }

    sub getCharset
    {
        my $self = shift;
    
        return "ISO-8859-1";
    }

    sub getSearchFieldsArray
    {
        return ['name'];
    }
}

1;
