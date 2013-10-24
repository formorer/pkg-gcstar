package GCPlugins::GCgames::GCJeuxVideoCom;

###################################################
#
#  Copyright 2005-2010 Tian
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
    package GCPlugins::GCgames::GCPluginJeuxVideoCom;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
        $self->{inside}->{$tagname}++;
        return if $self->{parsingEnded};
        if ($self->{parsingList})
        {
            if (($tagname eq 'div') && (($attr->{id} eq 'new_mc') || ($attr->{id} eq 'old_mc')))
            {
                $self->{inResults} = 1;
            }
            elsif ($self->{inResults})
            {
                if ($tagname eq 'img')
                {
                    $self->{currentPlatform} = $attr->{alt};
                }
                elsif (($tagname eq 'a') && ($attr->{href} =~ /^http/))
                {
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                    $self->{itemsList}[$self->{itemIdx}]->{platform} = $self->{currentPlatform};
                    $self->{isGame} = 1;
                }
            }
        }
        elsif ($self->{parsingTips})
        {
            if ($tagname eq 'tpfdebuttpf')
            {
                $self->{isTip} = 1;
            }
            elsif ( ($tagname eq 'h3') && ($attr->{class} eq 'titre_bloc') && ($self->{isTip} ne 4))
            {
                $self->{isTip} = 2;
            }
            elsif ( (($tagname eq 'h3') || ($tagname eq 'h4') || ($tagname eq 'h5') ) && ($self->{isTip} ne 3) && ($self->{isTip} ne 4))
            {
                $self->{isTip} = 2;
            }
            elsif ( ($tagname eq 'p') && ($self->{isTip} ne 3) && ($self->{isTip} ne 4))
            {
                $self->{isTip} = 1;
            }
            elsif ($tagname eq 'tpfstopsolution')
            {
                $self->{isTip} = 4;
            }
            elsif ($tagname eq 'tpffintpf')
            {
                $self->{isTip} = 3;
            }
            elsif ($tagname eq 'head')
            {
                $self->{isTip} = 0;
                $self->{urlTips} = '';
            }

        }
        else
        {
            if (($tagname eq 'meta') && ($attr->{property} eq 'og:image'))
            {
                my $cover = $attr->{content};
                $cover =~ s|(http://[^/]*)/([^i])|$1/images/$2|;
                if ($self->{bigPics})
                {
                    $cover =~ s/-p(-|\.)/-g$1/;
                    $cover =~ s/t(\.jpg)/$1/;
                }
                my $back = $cover;
                if (!($back =~ s/-avant(-|\.)/-arriere$1/))
                {
                    $back =~ s/f(t?\.jpg)/r$1/;
                }
                $self->{curInfo}->{boxpic} = $cover;
                $self->{curInfo}->{backpic} = $back;
            }
            elsif (($tagname eq 'li') && ($attr->{class} eq 'note_redac'))
            {
                 $self->{is} = 'ratingpress';
            }
            elsif ( ($tagname eq 'div') && ($attr->{class} eq 'series_images') )
            {
                    $self->{inScreenshots} = 1;
            }
            elsif ( ($tagname eq 'img') && ($self->{inScreenshots}) )
            {
                if (! $self->{curInfo}->{screenshot1})
                {
                    $self->{curInfo}->{screenshot1} = $attr->{src};
                    $self->{curInfo}->{screenshot1} =~ s/.gif/.jpg/;
                    $self->{curInfo}->{screenshot1} =~ s/_m\.jpg/\.jpg/;
                }
                elsif (! $self->{curInfo}->{screenshot2})
                {
                    $self->{curInfo}->{screenshot2} = $attr->{src};
                    $self->{curInfo}->{screenshot2} =~ s/.gif/.jpg/;
                    $self->{curInfo}->{screenshot2} =~ s/_m\.jpg/\.jpg/;
                    $self->{isScreen} = 0;
                }
            }
            elsif (($attr->{href} =~ m^/(etajvhtm|cheats)/^) && ! ($self->{urlTips}))
            {
                $self->{urlTips} = $attr->{href};
            }
            elsif (($attr->{href} =~ m/test.htm/) && ! ($self->{curInfo}->{players}))
            {
                my $html = $self->loadPage($attr->{href});

                my $found = index($html,"<li><strong>Multijoueurs :</strong>");
                if ( $found >= 0 )
                {
                    $html = substr($html, $found +length('<li><strong>Multijoueurs :</strong>'),length($html)- $found -length('<li><strong>Multijoueurs :</strong>'));
                    $self->{curInfo}->{players} = substr($html, 0, index($html, "<"));

                    # Enleve les blancs en debut de chaine
                    $self->{curInfo}->{players} =~ s/^\s+//;
                    # Enleve les blancs en fin de chaine
                    $self->{curInfo}->{players} =~ s/\s+$//;

                    $self->{curInfo}->{players} =~ s/-/1/;
                    $self->{curInfo}->{players} =~ s/non/1/i;
                    $self->{curInfo}->{players} =~ s/oui/Multijoueurs/i;
                }
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;
		
        $self->{inside}->{$tagname}--;
        return if $self->{parsingEnded};
        if ($self->{parsingList})
        {
            if ($tagname eq 'div')
            {
                $self->{inResults} = 0;
            }
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if $self->{parsingEnded};
        if ($self->{parsingList})
        {
            if ($self->{isGame})
            {
                $self->{itemsList}[$self->{itemIdx}]->{name} = $origtext;
                $self->{isGame} = 0;
            }
        }
        elsif ($self->{parsingTips})
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//;
            if ($self->{isTip} eq 2)
            {
                $self->{curInfo}->{secrets} .= "\n\n" if $self->{curInfo}->{secrets};
                $self->{curInfo}->{secrets} .= $origtext;
                $self->{isTip} = 0;
            }
            elsif ($self->{isTip} eq 1)
            {
                chomp($origtext);
                if ( ($self->{curInfo}->{secrets}) && ($origtext ne "") )
                {
                   $self->{curInfo}->{secrets} .= "\n"
                }
                $self->{curInfo}->{secrets} .= $origtext;
                $self->{isTip} = 0;
            }
        }
        else
        {
            if ($self->{inside}->{h1})
            {
                if ($self->{inside}->{a})
                {
                    $self->{curInfo}->{name} = $origtext;
                    $self->{curInfo}->{exclusive} = 1;
                }
                elsif ($self->{inside}->{span})
                {
                    if ($origtext !~ /^Fiche /)
                    {
                        $origtext =~ s/^\s*-?\s*//;
                        $self->{curInfo}->{platform} = $origtext;
                    }
                }
            }
            elsif ($self->{inside}->{strong})
            {
                $self->{is} = 'released' if ($origtext =~ /Sortie :/) || ($origtext =~ /Sortie France :/);
                $self->{is} = 'genre' if $origtext =~ /Type :/;
                $self->{is} = 'description' if $origtext =~ /Descriptif :/;
                $self->{is} = 'editor' if $origtext =~ /Editeur :/;
                $self->{is} = 'developer' if $origtext =~ /D.*?veloppeur :/;
                $self->{is} = 'players' if $origtext =~ /Multijoueurs :/;
                $self->{curInfo}->{exclusive} = 0 if $origtext =~ /Existe aussi sur :/;
            }
            elsif ($self->{is})
            {
                $origtext =~ s/^\s*//;
                $origtext =~ s/\n$//;
                if ($origtext)
                {
                    if ($self->{is} eq 'players')
                    {
                        $origtext =~ s/-/1/;
                        $origtext =~ s/non/1/i;
                        $origtext =~ s/oui/Multijoueurs/i;
                    }
                    if ($self->{is} eq 'ratingpress')
                    {
                        $origtext =~ m|(\d*)/20|;
                        $origtext = int($1 / 2);
                    }                
                    $self->{curInfo}->{$self->{is}} = $origtext;
                    $self->{is} = '';
                }
            }
        }
    } 

    sub getTipsUrl
    {
        my $self = shift;
        return $self->{urlTips};
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            name => 1,
            platform => 1
        };

        $self->{isTip} = 0;
        $self->{urlTips} = "";

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        if ($self->{parsingList})
        {
            $self->{parsingEnded} = 0;
            $self->{inResults} = 0;
            $self->{isGame} = 0;
        }
        elsif ($self->{parsingTips})
        {
            $html =~ s|<h4 class="lien_base"><a href="(.+)">Les astuces d|$self->RecupTips($1)|ge;
            $html =~ s|<h4 class="lien_base"><a href="(.+)">La solution d|$self->RecupSolution($1)|ge;
            $html =~ s|<h5><a href="(.+)">||gi;
            $html =~ s|<h3 class="titre_bloc"><span>Plus d'infos</span></h3>|<tpfstopsolution>|gi;
            $html =~ s|<div id="boxes_v">|<tpffintpf>|gi;
            $html =~ s|<p class="lien_base">|<tpffintpf>|gi;
            $html =~ s|<div class="player_article">|<tpffintpf>|gi;
            $html =~ s|</object>|<tpfdebuttpf>|gi;
            $html =~ s|<p class="title_bar">|<tpffintpf>|gi;
            $html =~ s|<div class="bloc3" id="astuces_ajout"><h3 class="titre_bloc">|<tpffintpf>|gi;
            $html =~ s|<br />|<p>|gi;
            $html =~ s|<kbd>|<p>|gi;
            $html =~ s|</kbd>||gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<span>||gi;
            $html =~ s|<img src="../pics/psx/cercle.gif"\s*(alt="CERCLE")?\s*/>|Cercle|gi;
            $html =~ s|<img src="../pics/psx/croix.gif"\s*(alt="CROIX")?\s*/>|Croix|gi;
            $html =~ s|<img src="../pics/psx/carre.gif"\s*(alt="CARRE")?\s*/>|Carr.|gi;
            $html =~ s|<img src="../pics/psx/triangle.gif"\s*(alt="TRIANGLE")?\s*/>|Triangle|gi;
            $html =~ s|<img src="http://image.jeuxvideo.com/pics/btajv/psx/cercle.gif"\s*(alt="CERCLE")?\s*/>|Cercle|gi;
            $html =~ s|<img src="http://image.jeuxvideo.com/pics/btajv/psx/croix.gif"\s*(alt="CROIX")?\s*/>|Croix|gi;
            $html =~ s|<img src="http://image.jeuxvideo.com/pics/btajv/psx/carre.gif"\s*(alt="CARRE")?\s*/>|Carr.|gi;
            $html =~ s|<img src="http://image.jeuxvideo.com/pics/btajv/psx/triangle.gif"\s*(alt="TRIANGLE")?\s*/>|Triangle|gi;
            $html =~ s|\x{92}|'|gi;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
            $html =~ s|&#156;|oe|gi;
            $html =~ s|&#133;|...|gi;
            $html =~ s|\x{85}|...|gi;
            $html =~ s|\x{8C}|OE|gi;
            $html =~ s|\x{9C}|oe|gi;
        }
        else
        {
            $self->{is} = '';
            $self->{inScreenshots} = 0;
        }
        return $html;
    }
    
    sub RecupTips
    {
        my ($self, $url) = @_;
        
        my $html = $self->loadPage($url);
        my $savenexturl = '';

        my $found = index($html,"<p class=\"astuces_suiv\"> <a href=\"");
        if ( $found >= 0 )
        {
            $savenexturl = substr($html, $found +length('<p class="astuces_suiv"> <a href="'),length($html)- $found -length('<p class="astuces_suiv"> <a href="'));
            $savenexturl = substr($savenexturl, 0, index($savenexturl, "\""));
        }

        $found = index($html,"<div id=\"astuce_detail\" class=\"astuce\">");
        if ( $found >= 0 )
        {
            $html = substr($html, $found +length('<div id="astuce_detail" class="astuce">'),length($html)- $found -length('<div id="astuce_detail" class="astuce">'));
            $html = substr($html, 0, index($html, "<div id=\"barre_outils_v2\">"));
            if ( $savenexturl ne "" )
            {
                $html .= $self->RecupTips($savenexturl);
            }
        }
        else
        {
            $html = '';
        }
        return "<tpfdebuttpf>" . $html . "<tpffintpf>";
    }

    sub RecupSolution
    {
        my ($self, $url) = @_;
        
        my $html = $self->loadPage($url);
        my $savenexturl = '';

        my $found = index($html,"<p class=\"astuces_suiv\"><a href=\"");
        if ( $found >= 0 )
        {
            $savenexturl = substr($html, $found +length('<p class="astuces_suiv"><a href="'),length($html)- $found -length('<p class="astuces_suiv"><a href="'));
            $savenexturl = substr($savenexturl, 0, index($savenexturl, "\""));
        }

        $found = index($html,"<div id=\"astuce_detail\" class=\"soluce\">");
        if ( $found >= 0 )
        {
            $html = substr($html, $found +length('<div id="astuce_detail" class="soluce">'),length($html)- $found -length('<div id="astuce_detail" class="soluce">'));
            $html = substr($html, 0, index($html, "<div id=\"barre_outils_v2\">"));
            if ( $savenexturl ne "" )
            {
                $html .= $self->RecupSolution($savenexturl);
            }
        }
        else
        {
            $html = '';
        }
        return "<tpfdebuttpf>" . $html . "<tpffintpf>";
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;
        $word =~ s/\+/ /g;
        return 'http://www.jeuxvideo.com/recherche/jeux/'.$word.'.htm';
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
		
        return $url if $url;
        return 'http://www.jeuxvideo.com/';
    }

    sub getName
    {
        return 'jeuxvideo.com';
    }
    
    sub getAuthor
    {
        return 'Tian & TPF';
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
