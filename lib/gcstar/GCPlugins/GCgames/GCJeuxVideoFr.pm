package GCPlugins::GCgames::GCJeuxVideoFr;

###################################################
#
#  Copyright 2005-2011 Tian
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
    package GCPlugins::GCgames::GCPluginJeuxVideoFr;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;
        if ($self->{parsingList})
        {
            if ($tagname eq 'div')
            {
                $self->{isGame} = 1
                    if $attr->{class} eq "jeuDesc";
            }
            if ($self->{isGame})
            {
                if ($tagname eq 'a')
                {
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                    $self->{itemsList}[$self->{itemIdx}]->{name} = $attr->{title};
                }
                elsif ( ($tagname eq 'span') & ($attr->{class} eq "bleu2"))
                {
                    $self->{isPlatform} = 1;
                }
                elsif ( ($tagname eq 'span') & ($attr->{class} eq "bleu6"))
                {
                    $self->{isGenre} = 1;
                }
                elsif ( ($tagname eq 'p') & ($attr->{class} eq "jeuNote"))
                {
                    $self->{isGame} = 0;
                    $self->{isEnd} = 1;
                }
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {
            if ( ($tagname eq 'input') && ($attr->{id} eq 'titreJeu'))
            {
                $self->{curInfo}->{name} = $attr->{value};
                $self->{curInfo}->{platform} = $self->{url_plateforme};

                my $html = $self->loadPage( $self->{url_screenshot} );

                my $found = index($html,"div class=\"image_slideshow\">");
                if ( $found >= 0 )
                {
                    $self->{curInfo}->{screenshot1} = substr($html, $found +length('div class="image_slideshow">'),length($html)- $found -length('div class="image_slideshow">'));
                    $found = index($self->{curInfo}->{screenshot1},"<a href=\"");
                    if ( $found >= 0 )
                    {
                        $self->{curInfo}->{screenshot1} = substr($self->{curInfo}->{screenshot1}, $found +length('<a href="'),length($self->{curInfo}->{screenshot1})- $found -length('<a href="'));
                        $self->{curInfo}->{screenshot1} = substr($self->{curInfo}->{screenshot1}, 0,index($self->{curInfo}->{screenshot1},"\""));
                        $found = index($html,"\"imageNumberTotal\"");
                        if ( $found >= 0 )
                        {
                            $self->{curInfo}->{screenshot2} = substr($html, $found +length('"imageNumberTotal"'),length($html)- $found -length('"imageNumberTotal"'));
                            $found = index($self->{curInfo}->{screenshot2},"href=\"");
                            if ( $found >= 0 )
                            {
                                $self->{curInfo}->{screenshot2} = substr($self->{curInfo}->{screenshot2}, $found +length('href="'),length($self->{curInfo}->{screenshot2})- $found -length('href="'));
                                $self->{curInfo}->{screenshot2} = 'http://www.jeuxvideo.fr/' . substr($self->{curInfo}->{screenshot2}, 0,index($self->{curInfo}->{screenshot2},"\""));

                                $html = $self->loadPage( $self->{curInfo}->{screenshot2} );
                                $found = index($html,"div class=\"image_slideshow\">");
                                if ( $found >= 0 )
                                {
                                    $self->{curInfo}->{screenshot2} = substr($html, $found +length('div class="image_slideshow">'),length($html)- $found -length('div class="image_slideshow">'));
                                    $found = index($self->{curInfo}->{screenshot2},"<a href=\"");
                                    if ( $found >= 0 )
                                    {
                                        $self->{curInfo}->{screenshot2} = substr($self->{curInfo}->{screenshot2}, $found +length('<a href="'),length($self->{curInfo}->{screenshot2})- $found -length('<a href="'));
                                        $self->{curInfo}->{screenshot2} = substr($self->{curInfo}->{screenshot2}, 0,index($self->{curInfo}->{screenshot2},"\""));
                                    }
                                }
                            }
                        }
                    }
                }
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'clearer spacer10'))
            {
                $self->{isInfo} = 0;
                $self->{is} = '';
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'listing_apropos'))
            {
                $self->{isInfo} = 1;
            }
            elsif (($self->{isInfo} eq '1') && ($tagname eq 'span') && ($attr->{class} eq 'strong'))
            {
                $self->{isInfo} = 2;
            }
            elsif (($self->{is}) && ($tagname eq 'span') && ($attr->{class} eq 'noir'))
            {
                $self->{isInfo} = 3;
            }
            elsif (($self->{is})  && ($tagname eq 'div') && ($attr->{class} eq 'clearer'))
            {
                $self->{isInfo} = 1;
                $self->{is} = '';
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'note-jeux orange1') && ($attr->{property} eq 'v:rating'))
            {
                $self->{isNote} = 1;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'contentCommentaire'))
            {
                $self->{isDesc} = 1;
            }
            elsif (($self->{isDesc})  && ($tagname eq 'div') && ($attr->{class} eq 'clearer'))
            {
                $self->{isDesc} = 0;
            }
            elsif ( ($tagname eq 'img') && ($attr->{class} eq 'imgJeu') && !($attr->{src} =~ /blank/i))
            {
                $self->{curInfo}->{boxpic} = $attr->{src};
            }
        }
    }

    sub end
    {
		my ($self, $tagname) = @_;
		
        $self->{inside}->{$tagname}--;
        if ($self->{parsingList})
        {
        }
        elsif ($self->{parsingTips})
        {
        }
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

            if ($self->{isGenre})
            {
                if ($self->{itemsList}[$self->{itemIdx}]->{genre} eq '')
                {
                   $self->{itemsList}[$self->{itemIdx}]->{genre} = $origtext;
                   $self->{isGenre} = 0;
                }
                else
                {
                   $self->{itemsList}[$self->{itemIdx}]->{genre} = $self->{itemsList}[$self->{itemIdx}]->{genre} . ' - ' . $origtext;
                   $self->{isGenre} = 0;
                }
            }
            elsif ($self->{isPlatform})
            {
                $origtext =~ s/\|//gi;
                if ($self->{itemsList}[$self->{itemIdx}]->{platform} eq '')
                {
                    $self->{itemsList}[$self->{itemIdx}]->{platform} = $origtext;
                }
                else
                {
                    $self->{itemsList}[$self->{itemIdx}]->{platform} .= ', ';
                    $self->{itemsList}[$self->{itemIdx}]->{platform} .= $origtext;
                }
                $self->{isPlatform} = 0;
            }
            elsif ($self->{isEnd})
            {
                my @array = split(/,/,$self->{itemsList}[$self->{itemIdx}]->{platform});
                my $element;

                my $SaveName = $self->{itemsList}[$self->{itemIdx}]->{name};
                my $SaveUrl = $self->{itemsList}[$self->{itemIdx}]->{url};
                my $SaveGenre = $self->{itemsList}[$self->{itemIdx}]->{genre};
                $self->{itemIdx}--;

                foreach $element (@array)
                {
                   # Enleve les blancs en debut de chaine
                   $element =~ s/^\s+//;
                   # Enleve les blancs en fin de chaine
                   $element =~ s/\s+$//;

                   $self->{itemIdx}++;
                   $self->{itemsList}[$self->{itemIdx}]->{name} = $SaveName;
                   $self->{itemsList}[$self->{itemIdx}]->{url} = $SaveUrl . 'tpfplatformtpf' . $element;
                   $self->{itemsList}[$self->{itemIdx}]->{platform} = $element;
                   $self->{itemsList}[$self->{itemIdx}]->{genre} = $SaveGenre;
                }
                $self->{isEnd} = 0;
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {
            if ($self->{isInfo} eq 2)
            {
                $self->{is} = 'genre' if $origtext =~ /Genre :/;
                $self->{is} = 'editor' if $origtext =~ /Editeur :/;
                $self->{is} = 'developer' if $origtext =~ /D.veloppeur :/;
                $self->{is} = 'players' if $origtext =~ /Nb joueurs :/;
                $self->{is} = 'released' if $origtext =~ /Sortie :/;
                $self->{is} = 'exclusive' if $origtext =~ /Plateformes :/;
            }
            elsif ($self->{isInfo} eq 3)
            {
                # Enleve le caractere | qui separe les champs
                $origtext =~ s/\|//gi;
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//;
                if ($origtext)
                {
                   if ($self->{is} eq 'players')
                   {
                       $origtext =~ s/Exclusivement Solo/1/i;
                       $origtext =~ s/\s*joueurs?//i;
                   }

                   if ($self->{curInfo}->{$self->{is}} eq '')
                   {
                       if ($self->{is} eq 'exclusive')
                       {
                           $self->{curInfo}->{$self->{is}} = 'true';
                           if ($origtext =~ /$self->{curInfo}->{platform}/i)
                           {
                               $self->{curInfo}->{platform} = $origtext;
                           }
                       }
                       else
                       {
                           $self->{curInfo}->{$self->{is}} = $origtext;
                       }
                   }
                   else
                   {
                       if ($self->{is} eq 'exclusive')
                       {
                           $self->{curInfo}->{$self->{is}} = 'false';
                           if ($origtext =~ /$self->{curInfo}->{platform}/i)
                           {
                               $self->{curInfo}->{platform} = $origtext;
                           }
                       }
                       else
                       {
                           $self->{curInfo}->{$self->{is}} = $self->{curInfo}->{$self->{is}} . ', ' . $origtext;
                       }
                   }

                }
            }
            elsif ($self->{isNote} eq 1)
            {
                $self->{curInfo}->{ratingpress} = $origtext;
                $self->{isNote} = 0;
            }
            elsif ($self->{isDesc} eq 1)
            {
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//;
                $self->{curInfo}->{description} .= $origtext;
            }
        }
    } 

    sub getTipsUrl
    {
        my $self = shift;
        
        return $self->{url_tips};
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
            released => 0,
            genre => 1
        };

        $self->{isGame} = 0;
        $self->{isPlatform} = 0;
        $self->{isGenre} = 0;
        $self->{isEnd} = 0;
        $self->{isInfo} = 0;
        $self->{isNote} = 0;
        $self->{isDesc} = 0;
        $self->{isTip} = 0;
        $self->{url_plateforme} = '';
        $self->{url_screenshot} = '';
        $self->{url_tips} = '';
        $self->{is} = '';

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {
            $html =~ s|<br />|\n|gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
        }

        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        return 'http://www.jeuxvideo.fr/r/'.$word.'/';
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
		
        my $found = index($url,"tpfplatformtpf");
        if ( $found >= 0 )
        {
            $self->{url_plateforme} = substr($url, $found +length('tpfplatformtpf'),length($url)- $found -length('tpfplatformtpf'));
            $url = substr($url, 0,$found);
        }

        $self->{url_screenshot} = 'http://www.jeuxvideo.fr' . $url . 'image-photo/';
        $self->{url_tips} = 'http://www.jeuxvideo.fr' . $url . 'astuce-code/';

        return 'http://www.jeuxvideo.fr' . $url;
    }

    sub getName
    {
        return 'jeuxvideo.fr';
    }
    
    sub getAuthor
    {
        return 'Tian';
    }
    
    sub getLang
    {
        return 'FR';
    }

    sub getCharset
    {
        my $self = shift;
    
        return "ISO-8859-1";
    }

    sub isPreferred
    {
        return 1;
    }

}

1;
