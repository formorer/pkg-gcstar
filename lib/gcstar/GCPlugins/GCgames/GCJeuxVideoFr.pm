package GCPlugins::GCgames::GCJeuxVideoFr;

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
    package GCPlugins::GCgames::GCPluginJeuxVideoFr;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;
        if ($self->{parsingList})
        {
            if ($tagname eq 'tr')
            {
                $self->{isGame} = 1
                    if $attr->{class} =~ /listel[1-2]/;
            }
            if ($self->{isGame})
            {
                if ($tagname eq 'img')
                {
                    if ($attr->{src} =~ m|/style/img/supv.*?([a-z0-9]*)\.gif|)
                    {
                        $self->{itemIdx}++;
                        $self->{itemsList}[$self->{itemIdx}]->{platform} = uc $1;
                        $self->{itemsList}[$self->{itemIdx}]->{platform} =~ s|REV|WII|;
                    }
                }
                elsif (($tagname eq 'a') && ($self->{isName}))
                {
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                    $self->{itemsList}[$self->{itemIdx}]->{name} = $attr->{title};
                    $self->{isName} = 0;
                }
                elsif ($tagname eq 'td')
                {
                    $self->{isName} = 1 if $attr->{class} eq 'titre';
                    $self->{isDate} = 1 if $attr->{class} eq 'datesortie';
                    $self->{isGenre} = 1 if $attr->{class} eq 'genre';
                }
            }
        }
        elsif ($self->{parsingTips})
        {
            if (
                (($tagname eq 'h2') && ($attr->{class} eq 'simple'))
                ||
                (($tagname eq 'div') && ($attr->{class} eq 'desc'))
               )
            {
                $self->{isTip} = 1;
            }
            
        }
        else
        {
           if ($attr->{id} eq 'fiche_technique_jeu')
            {
                $self->{isInfo} = 1;
                $self->{is} = '';

                my $html = $self->loadPage( 'http://www.jeuxvideo.fr/fiche/fiche_v2_ajax.php', ["id" => "$self->{id_plateforme}", "type" => "fiche", "tab_limit" => "captures:2|", "page" => "0"] );

                my $found = index($html,"\$\('#x_pochette'\).attr\(\"src\",\"");
                if ( $found >= 0 )
                {
                    $self->{curInfo}->{boxpic} = substr($html, $found +length('$(\'#x_pochette\').attr("src","'),length($html)- $found -length('$(\'#x_pochette\').attr("src","'));
                    $self->{curInfo}->{boxpic} = substr($self->{curInfo}->{boxpic}, 0, index($self->{curInfo}->{boxpic}, "\""));
                    $found = index($self->{curInfo}->{boxpic},"http");
                    if ( $found < 0)
                    {
                        $self->{curInfo}->{boxpic} = '';
                    }
                }

                $found = index($html,"\$\('.txt_supp'\).html\(\"");
                if ( $found >= 0 )
                {
                    $self->{curInfo}->{platform} = substr($html, $found +length('$(\'.txt_supp\').html("'),length($html)- $found -length('$(\'.txt_supp\').html("'));
                    $self->{curInfo}->{platform} = substr($self->{curInfo}->{platform}, 0, index($self->{curInfo}->{platform}, "\""));
                }

                $found = index($html,"\$\('#capt0'\).attr\('href','");
                if ( $found >= 0 )
                {
                    $self->{curInfo}->{screenshot1} = substr($html, $found +length('$(\'#capt0\').attr(\'href\',\''),length($html)- $found -length('$(\'#capt0\').attr(\'href\',\''));
                    $self->{curInfo}->{screenshot1} = substr($self->{curInfo}->{screenshot1}, 0, index($self->{curInfo}->{screenshot1}, "'"));
                }

                $found = index($html,"\$\('#capt1'\).attr\('href','");
                if ( $found >= 0 )
                {
                    $self->{curInfo}->{screenshot2} = substr($html, $found +length('$(\'#capt1\').attr(\'href\',\''),length($html)- $found -length('$(\'#capt1\').attr(\'href\',\''));
                    $self->{curInfo}->{screenshot2} = substr($self->{curInfo}->{screenshot2}, 0, index($self->{curInfo}->{screenshot2}, "'"));
                }

                $found = index($html,"\$\('#wid_sortie').append(\"");
                if ( $found >= 0 )
                {
                    $self->{curInfo}->{released} = substr($html, $found +length('$(\'#wid_sortie\').append("'),length($html)- $found -length('$(\'#wid_sortie\').append("'));

                    $found = index($self->{curInfo}->{released},"/style/img/flag_fr_mini.gif");
                    if ( $found >= 0 )
                    {
                        $self->{curInfo}->{released} = substr($self->{curInfo}->{released}, $found +length('/style/img/flag_fr_mini.gif'),length($self->{curInfo}->{released})- $found -length('/style/img/flag_fr_mini.gif'));
                        $found = index($self->{curInfo}->{released},"/>");
                        if ( $found >= 0 )
                        {
                            $self->{curInfo}->{released} = substr($self->{curInfo}->{released}, $found +length('/>'),length($self->{curInfo}->{released})- $found -length('/>'));
                            $self->{curInfo}->{released} = substr($self->{curInfo}->{released}, 0, index($self->{curInfo}->{released}, "<"));
                            # Enleve les blancs en debut de chaine
                            $self->{curInfo}->{released} =~ s/^\s+//;
                            # Enleve les blancs en fin de chaine
                            $self->{curInfo}->{released} =~ s/\s+$//;
                        }
                    }
                    else
                    {
                        $self->{curInfo}->{released} = '';
                    }
                }

                $self->{url_plateforme} = '';
                $self->{id_plateforme} = 0;
            }
            elsif (($self->{isInfo} eq '1') && ($tagname eq 'th'))
            {
                $self->{isInfo} = 2;
            }
            elsif ($attr->{class} eq 'titre_page')
            {
                $self->{is} = 'name';
            }
        }
    }

    sub end
    {
		my ($self, $tagname) = @_;
		
        $self->{inside}->{$tagname}--;
        if ($self->{parsingList})
        {
            $self->{isGame} = 0
                if ($tagname eq 'tr');
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

            if ($self->{isDate})
            {
                $self->{itemsList}[$self->{itemIdx}]->{released} = $origtext;
                $self->{isDate} = 0;
            }
            elsif ($self->{isGenre})
            {
                $self->{itemsList}[$self->{itemIdx}]->{genre} = $origtext;
                $self->{isGenre} = 0;
            }
        }
        elsif ($self->{parsingTips})
        {
            if ($self->{isTip})
            {
                $self->{curInfo}->{secrets} .= "\n\n" if $self->{curInfo}->{secrets};
                $self->{curInfo}->{secrets} .= $origtext;
                $self->{isTip} = 0;
            }
        }
        else
        {
            if ($self->{isInfo} eq 2)
            {
                $self->{is} = 'genre' if $origtext =~ /Genre/;
                $self->{is} = 'editor' if $origtext =~ /Editeur/;
                $self->{is} = 'developer' if $origtext =~ /D.veloppeur/;
                $self->{is} = 'players' if $origtext =~ /Type de jeu/;
                $self->{isInfo} = 1;
            }
            elsif (($self->{is}) && ($origtext))
            {
                $origtext =~ s/^\s*//;
                if ($origtext)
                {
                   if ($self->{is} eq 'players')
                   {
                       $origtext =~ s/Exclusivement Solo/1/;
                       $origtext =~ s/\s*joueurs?//i;
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
        
        my $url = $self->{curInfo}->{$self->{urlField}};
        $url =~ s/fiche-/astuce-/;
        return $url;
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
            released => 1,
            genre => 1
        };

        $self->{isName} = 0;
        $self->{isGame} = 0;
        $self->{isDate} = 0;
        $self->{isGenre} = 0;
        $self->{isInfo} = 0;
        $self->{isTip} = 0;
        $self->{url_plateforme} = '';
        $self->{id_plateforme} = 0;
        $self->{is} = '';

        $self->{key} = {
                        b => 'Bas',
                        h => 'Haut',
                        g => 'Gauche',
                        d => 'Droite'
                       };

        return $self;
    }

    sub toKey
    {
        my ($self, $value) = @_;
        
        if (length($value) <= 2)
        {
            $value = substr($value, 0, 1);
        }
        elsif ($value =~ /_/)
        {
            $value =~ s/(.)_(.)/$self->{key}->{$1}.'-'.$self->{key}->{$2}/ge;
        }
        else
        {
            $value = ucfirst $value;            
        }
        
        return $value;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|<br />|, |;
        }
        elsif ($self->{parsingTips})
        {
            $html =~ s|<b>(.*?)</b>|$1|gi;
            $html =~ s|<img src='http://www\.jeuxvideo\.fr/style/img/man/bt_([a-z_]*)\.gif' align='absmiddle'>|$self->toKey($1)|ge;
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
	
        return 'http://www.jeuxvideo.fr/encyclopedie-jeux-video-ds-gba-gc-pc-ps2-psp-xbox-xbox360-ps3-rev-iphone---g0g-0-0-0.html?recherche='.$word;
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
                my $found = index($url,"#");
                if ( $found >= 0 )
                {
                    $self->{url_plateforme} = substr($url, $found +length('#'),length($url)- $found -length('#'));
                }

                my $html = $self->loadPage( 'http://www.jeuxvideo.fr' . $url );
                if ( $self->{url_plateforme} eq '' )
                {
                    $found = index($html,"var top_pf = \"");
                    if ( $found >= 0 )
                    {
                        $self->{url_plateforme} = substr($html, $found +length('var top_pf = "'),length($html)- $found -length('var top_pf = "'));
                        $self->{url_plateforme} = substr($self->{url_plateforme}, 0, index($self->{url_plateforme},"\""));
                        $self->{url_plateforme} =~ s|pf_||;
                    }
                }

                $found = index($html,"tab_pf['" . $self->{url_plateforme} . "']");
                if ( $found >= 0 )
                {
                    $self->{id_plateforme} = substr($html, $found +length('tab_pf[\'' . $self->{url_plateforme} . '\']' ),length($html)- $found -length('tab_pf[\'' . $self->{url_plateforme} . '\']'));
                    $self->{id_plateforme} = substr($self->{id_plateforme}, index($self->{id_plateforme},"=") + 1 , index($self->{id_plateforme},";") - 2 );
                }
                else
                {
                    $found = index($html,"plateforme au chargement");
                    if ( $found >= 0 )
                    {
                        $self->{id_plateforme} = substr($html, $found +length('plateforme au chargement' ),length($html)- $found -length('plateforme au chargement'));
                        $found = index($self->{id_plateforme},"id_defaut:'");
                        if ( $found >= 0 )
                        {
                            $self->{id_plateforme} = substr($self->{id_plateforme}, $found +length('id_defaut:\'' ),length($self->{id_plateforme})- $found -length('id_defaut:\''));
                            $self->{id_plateforme} = substr($self->{id_plateforme}, 0, index($self->{id_plateforme}, "'"));
                        }
                    }
                }


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
}

1;
