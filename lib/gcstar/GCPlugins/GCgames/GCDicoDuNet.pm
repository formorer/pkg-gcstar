package GCPlugins::GCgames::GCDicoDuNet;

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
    package GCPlugins::GCgames::GCPluginDicoDuNet;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if (($tagname eq 'div') && ($attr->{class} eq 'cat_produit'))
            {
                $self->{isGame} = 1 ;
                $self->{isUrl} = 1 ;
            }
            elsif (($tagname eq 'a') && ($self->{isUrl}) && ($self->{isGame}))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                $self->{isUrl} = 0 ;
            }
            elsif (($tagname eq 'strong') && ($self->{isGame}))
            {
                $self->{isName} = 1 ;
                $self->{isGame} = 0 ;
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {

            if (($tagname eq 'h3') && ($attr->{class} eq 'produits'))
            {
                $self->{isGame} = 1 ;
            }
            elsif (($tagname eq 'span') && ($self->{isGame} eq 1) )
            {
                $self->{isName} = 1 ;
                $self->{isGame} = 2 ;
            }
            elsif (($tagname eq 'a') && ($self->{isGame} eq 2))
            {
                $self->{isEditor} = 1 ;
                $self->{isGame} = 0 ;
            }
            elsif ($tagname eq 'table')
            {
                $self->{isGame} = 0 ;
            }
            elsif (($tagname eq 'div') && ($attr->{id} eq 'vous_etes_ici'))
            {
                $self->{isPlatform} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} ne 'http://www.dicodunet.com/jeux-video/') && ($self->{isPlatform}))
            {
                $self->{isPlatform} = 2 ;
            }
            elsif (($tagname eq 'a') && (index($attr->{href},"www.dicodunet.com/jeux-video/img/") >= 0) && ($self->{curInfo}->{boxpic} eq ''))
            {
                my $html = $self->loadPage($attr->{href}, 0, 1);
                my $found = index($html,"<h3 class=\"produits\">");
                if ( $found >= 0 )
                {
                   $html = substr($html, $found +length('<h3 class="produits">'),length($html)- $found -length('<h3 class="produits">'));

                   my $found = index($html,"<img src=\"");
                   if ( $found >= 0 )
                   {
                      $html = substr($html, $found +length('<img src="'),length($html)- $found -length('<img src="'));
                      $html = substr($html, 0,index($html,"\""));

                      $self->{curInfo}->{boxpic} = $html;
                   }
                }

            }
            elsif ($tagname eq 'tpfdateparution')
            {
                $self->{isDate} = 1 ;
            }
            elsif ($tagname eq 'tpfean')
            {
                $self->{isEan} = 1 ;
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
            }
            elsif ($self->{isEditor})
            {
                $self->{curInfo}->{editor} = $origtext;
                $self->{isEditor} = 0 ;
            }
            elsif ($self->{isPlatform} eq 2)
            {
                $origtext =~ s/PlayStation 2/Playstation 2/i;
                $origtext =~ s/Jeux PC/PC/i;
                $origtext =~ s/Jeux Mac/MAC/i;

                if (($self->{curInfo}->{platform} eq '') && ($origtext ne ''))
                {
                   $self->{curInfo}->{platform} = $origtext;
                }
                elsif ($origtext ne '')
                {
                   $self->{curInfo}->{platform} .= ', ';
                   $self->{curInfo}->{platform} .= $origtext;
                }
                $self->{isPlatform} = 0;
            }
            elsif ($self->{isDate})
            {
                $self->{curInfo}->{released} = $origtext;
                $self->{curInfo}->{released} =~ s|([0-9]*)-([0-9]*)-([0-9]*)|$3.'/'.$2.'/'.$1|e;
                $self->{isDate} = 0 ;
            }
            elsif ($self->{isEan})
            {
                $self->{curInfo}->{ean} = $origtext;
                $self->{isEan} = 0 ;
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

        $self->{isName} = 0;
        $self->{isGame} = 0;
        $self->{isUrl} = 0;
        $self->{isPlatform} = 0;
        $self->{isEditor} = 0;
        $self->{isDate} = 0;
        $self->{isEan} = 0;

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
            my $found = index($html,"class=\"produits_box\"");
            if ( $found >= 0 )
            {
               $html = substr($html, 0, $found);
            }

            $html =~ s/Version sortie le /<tpfdateparution>/gi;
            $html =~ s/Code EAN : /<tpfean>/gi;
            $html =~ s|\x{92}|'|gi;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
        }
        return $html;
    }
    
    sub getSearchUrl
    {
        my ($self, $word) = @_;

        return ('http://www.dicodunet.com/jeux-video/recherche.php', ["q" => "$word"] );
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
        return $url if $url;
        return 'http://www.dicodunet.com/';
    }

    sub getName
    {
        return 'DicoDuNet';
    }
    
    sub getCharset
    {
        my $self = shift;
        #return "UTF-8";
        return "ISO-8859-15";
    }

    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'FR';
    }

    sub getSearchFieldsArray
    {
        return ['name'];
    }
}

1;

