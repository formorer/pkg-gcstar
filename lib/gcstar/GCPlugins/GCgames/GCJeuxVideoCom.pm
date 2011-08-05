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
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
            if ($tagname eq 'ul')
            {
                    if ( $attr->{class} eq 'liste_liens on' )
                    {
                        $self->{isGame} = 1 ;
                    }
            }
            elsif ($tagname eq 'img')
            {
                    if ( $attr->{alt}  )
                    {
                        $self->{SavePlatform} = $attr->{alt} ;
                    }
                    if ($attr->{src} =~ /t_jeux_populaires/)
                    {
                        $self->{parsingEnded} = 1;
                    }
            }
            elsif ($self->{isGame})
            {
                if ($tagname eq 'a')
                {
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                    $self->{itemsList}[$self->{itemIdx}]->{platform} = $self->{SavePlatform};
                    $self->{itemsList}[$self->{itemIdx}]->{platform} =~ s/Playstation Portable/PSP/;
                    $self->{isName} = 1 ;
                }
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'bloc3'))
            {
                $self->{parsingEnded} = 1;
            }
        }
        elsif ($self->{parsingTips})
        {
            if (($tagname eq 'h3') && ($self->{isTip} ne 3))
            {
                $self->{isTip} = 2;
            }
            elsif ( (($tagname eq 'p') || ($tagname eq 'h5') || ($tagname eq 'h4') ) && ($self->{isTip} ne 3))
            {
                $self->{isTip} = 1;
            }
            elsif ($tagname eq 'tpfstopsolution')
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

            if ($tagname eq 'h2')
            {
                    $self->{is} = 'name';
            }
            elsif ( ($tagname eq 'img') && ($self->{curInfo}->{name}) && ($self->{curInfo}->{platform} eq '') )
            {
                    $self->{curInfo}->{platform} = $attr->{alt};
                    $self->{curInfo}->{platform} =~ s/Playstation Portable/PSP/;
            }
            elsif ($tagname eq 'strong')
            {
                   $self->{isStrong} = 1;
            }
            elsif ( ($tagname eq 'a') && ($self->{isEditor}))
            {
                    if ($self->{curInfo}->{editor} eq '')
                    {
                        $self->{is} = 'editor';
                    }
                    $self->{isEditor} = 0;
            }
            elsif ($self->{isDeveloper})
            {
                    if ($self->{curInfo}->{developer} eq '')
                    {
                        $self->{is} = 'developer';
                    }
                    $self->{isDeveloper} = 0;
            }
            elsif (!$self->{bigPics} && ($tagname eq 'li') && ($attr->{class} eq 'jaquette') )
            {
                    $self->{isBox} = 1;
            }
            elsif ( ($tagname eq 'img') && ($self->{isBox}) )
            {
                    if (( $attr->{src} ne "http://image.jeuxvideo.com/pics/pasdimage2.gif" ) && ($attr->{src} ne "http://image.jeuxvideo.com/pics/pasdimage.gif") && ($attr->{src} ne "http://image.jeuxvideo.com/pics/pasjaquette.gif"))
                    {
                        $self->{curInfo}->{boxpic} = $attr->{src};
                        $self->{curInfo}->{boxpic} =~ s/20ft.jpg/20f.jpg/;
                        # Si on veut recuperer l arriere de la jaquette en petit format il faut remplacer avant-p par arriere-p depuis boxpic
                        # Par contre je ne sais pas comment tester si une image existe ou pas.
                        $self->{curInfo}->{backpic} = $self->{curInfo}->{boxpic};
                        $self->{curInfo}->{backpic} =~ s/avant-p/arriere-p/;
                        if (($self->{curInfo}->{backpic} eq $self->{curInfo}->{boxpic}) || (!$self->url_exists($self->{curInfo}->{backpic})))
                        {
                            $self->{curInfo}->{backpic} = '';
                        }
                    }
                    $self->{isBox} = 0;
            }
            elsif ( ($tagname eq 'div') && ($attr->{class} eq 'series_images') )
            {
                    $self->{isScreen} = 1;
            }
            elsif ( ($tagname eq 'div') && ($attr->{id} eq 'fiche_infos') )
            {
                    $self->{isScreen} = 0;
            }
            elsif ( ($tagname eq 'img') && ($self->{isScreen}) )
            {
                if ($self->{curInfo}->{screenshot1} eq '')
                {
                    $self->{curInfo}->{screenshot1} = $attr->{src};
                    $self->{curInfo}->{screenshot1} =~ s/.gif/.jpg/;
                }
                elsif ($self->{curInfo}->{screenshot2} eq '')
                {
                    $self->{curInfo}->{screenshot2} = $attr->{src};
                    $self->{curInfo}->{screenshot2} =~ s/.gif/.jpg/;
                    $self->{isScreen} = 0;
                }
            }
            elsif ($tagname eq 'a')
            {
                if ($self->{bigPics} && ($attr->{href} =~ m|/affpic.htm\?(.*)$|))
                {
                    if (!$self->{curInfo}->{boxpic})
                    {
                        $self->{curInfo}->{boxpic} = 'http://image.jeuxvideo.com/'.$1
                    }
                    elsif (!$self->{curInfo}->{backpic})
                    {
                        $self->{curInfo}->{backpic} = 'http://image.jeuxvideo.com/'.$1
                    }
                }
                elsif (($attr->{href} =~ m^/(etajvhtm|cheats)/^) && ! ($self->{urlTips}))
                {
                    $self->{urlTips} = $attr->{href};
                }
                elsif (!$self->{curInfo}->{description} && ($attr->{href} =~ /[-_]test\.htm$/) && (!$self->{testLoaded}))
                {
                    my $html = $self->loadPage($attr->{href}, 0, 1);
                    my $found = index($html,"<p id=\"chapo\">");
                    if ( $found >= 0 )
                    {
                        my $html_Desc = substr($html, $found +length('<p id="chapo">'),length($html)- $found -length('<p id="chapo">'));
                        $html_Desc = substr($html_Desc,index($html_Desc,"<strong>") + length("<strong>"),index($html_Desc,"</strong>")-index($html_Desc,"<strong>")-length("<strong>") );
                        $html_Desc =~ s|\x{92}|'|gi;
                        #'
                        $self->{curInfo}->{description} = $html_Desc;
                    }
                    $self->{testLoaded} = 1;
                }
            }
            elsif (($tagname eq 'li') && ($attr->{class} eq 'note_redac'))
            {
                 $self->{is} = 'ratingpress';
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
            if ($tagname eq 'ul')
            {
              $self->{isGame} = 0;
            }
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if $self->{parsingEnded};
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
            if ($self->{isStrong})
            {
                $self->{is} = '';
                $self->{is} = 'released' if ($origtext =~ /Sortie :/) || ($origtext =~ /Sortie France :/);
                $self->{is} = 'genre' if $origtext =~ /Type :/;
                $self->{is} = 'description' if $origtext =~ /Descriptif :/;
                $self->{is} = 'editor' if $origtext =~ /Editeur :/;
                $self->{isEditor} = 1 if $origtext =~ /Editeur :/;
                $self->{is} = 'developer' if $origtext =~ /D.*?veloppeur :/;
                $self->{isDeveloper} = 'developer' if $origtext =~ /D.*?veloppeur :/;
                $self->{is} = 'players' if $origtext =~ /Multijoueurs :/;
                $self->{isStrong} = 0;
            }
            elsif ($self->{is})
            {
                $origtext =~ s/^\s*//;
                $origtext =~ s/\n$//;
                
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

    sub getTipsUrl
    {
        my $self = shift;
        return $self->{urlTips};
        #my $html = $self->loadPage($self->{urlTips}, 0, 1);
        #$html =~ m|<div id="col1">(.*?)<div id="barre_outils">|ms;
        #$self->{curInfo}->{secrets} = $1;
        #return '';
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

        $self->{isName} = 0;
        $self->{isGame} = 0;
        $self->{isEditor} = 0;
        $self->{isDeveloper} = 0;
        $self->{isBox} = 0;
        $self->{isScreen} = 0;
        $self->{isTip} = 0;
        $self->{SavePlatform} = "";
        $self->{is} = '';
        $self->{isStrong} = '';
        $self->{urlTips} = "";

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        $self->{parsingEnded} = 0;
        if ($self->{parsingTips})
        {
            $html =~ s|<li><a href="(.+)">|$self->RecupTips($1)|ge;
            $html =~ s|<h4 class="lien_base"><a href="(.+)">La solution d|$self->RecupSolution($1)|ge;
            $html =~ s|<h5><a href="(.+)">||gi;
            $html =~ s|<h3 class="titre_bloc"><span>Plus d'infos</span></h3>|<tpfstopsolution>|gi;
            $html =~ s|<br />|<p>|gi;
            $html =~ s|<kbd>|<p>|gi;
            $html =~ s|</kbd>||gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<img src="../pics/psx/cercle.gif"\s*(alt="CERCLE")?\s*/>|Cercle|gi;
            $html =~ s|<img src="../pics/psx/croix.gif"\s*(alt="CROIX")?\s*/>|Croix|gi;
            $html =~ s|<img src="../pics/psx/carre.gif"\s*(alt="CARRE")?\s*/>|Carré|gi;
            $html =~ s|<img src="../pics/psx/triangle.gif"\s*(alt="TRIANGLE")?\s*/>|Triangle|gi;
            $html =~ s|<img src="http://image.jeuxvideo.com/pics/btajv/psx/cercle.gif"\s*(alt="CERCLE")?\s*/>|Cercle|gi;
            $html =~ s|<img src="http://image.jeuxvideo.com/pics/btajv/psx/croix.gif"\s*(alt="CROIX")?\s*/>|Croix|gi;
            $html =~ s|<img src="http://image.jeuxvideo.com/pics/btajv/psx/carre.gif"\s*(alt="CARRE")?\s*/>|Carré|gi;
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
        $self->{testLoaded} = 0;
        return $html;
    }
    
    sub RecupTips
    {
        my ($self, $url) = @_;
        
        my $html = $self->loadPage($url);

        my $found = index($html,"<div id=\"astuce_detail\" class=\"astuce\">");
        if ( $found >= 0 )
        {
            $html = substr($html, $found +length('<div id="astuce_detail" class="astuce">'),length($html)- $found -length('<div id="astuce_detail" class="astuce">'));
            $html = substr($html, 0, index($html, "<div class=\"barre_outils\"><ul>"));
        }
        else
        {
            $html = '';
        }
        return $html;
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
            $html = substr($html, 0, index($html, "<p class=\"lien_base\">")) if (index($html, "<p class=\"lien_base\">") >= 0 );
            $html = substr($html, 0, index($html, "<div class=\"barre_outils\"><ul>"));
            if ( $savenexturl ne "" )
            {
                $html .= "<h3>" . $self->RecupSolution($savenexturl);
            }
        }
        else
        {
            $html = '';
        }
        return $html;
    }

    sub url_exists
    {
        my ($self, $url_a_tester) = @_;

        my $html = $self->loadPage($url_a_tester, 0, 0);
        my $found = index($html,"<body>");
        if ( $found >= 0 )
        {
            return 0;
        }
        else
        {
            return 1;
        }
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
        return 'TPF';
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
