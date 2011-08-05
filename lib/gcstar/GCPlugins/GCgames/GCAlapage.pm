package GCPlugins::GCgames::GCAlapage;

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

use GCPlugins::GCgames::GCgamesCommon;

{
    package GCPlugins::GCgames::GCPluginAlapage;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if (($tagname eq 'div') && ($attr->{class} eq 'infos_produit'))
            {
                $self->{isGame} = 1 ;
                $self->{isUrl} = 1 ;
            }
            elsif ($tagname eq 'div')
            {
                $self->{isGame} = 0 ;
            }
            elsif (($tagname eq 'a') && ($self->{isUrl}) && ($self->{isGame}))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                $self->{itemsList}[$self->{itemIdx}]->{name} = $attr->{title};
                $self->{isUrl} = 0 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"mot_consoles") >= 0) && ($self->{isGame}))
            {
                $self->{isPlatform} = 1 ;
            }
        }
        elsif ($self->{parsingTips})
        {
        }
        else
        {

            if ($tagname eq 'h2')
            {
                $self->{isName} = 1 ;
            }
            elsif (($tagname eq 'tpfcommentaire') && ($self->{isDescription} eq 1))
            {
                $self->{isDescription} = 2 ;
            }
            elsif ($self->{isDate} eq 1)
            {
                $self->{isDate} = 2 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"mot_consoles") >= 0))
            {
                $self->{isPlatform} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{class} eq 'thickbox tooltip') && ($self->{curInfo}->{boxpic} eq ''))
            {
                   my $html = $self->loadPage( "http://www.alapage.com" . $attr->{href}, 0, 1 );
                   my $found = index($html,"\"laplusgrande\"");
                   if ( $found >= 0 )
                   {
                      my $found2 = index($html,"&m=v");
                      $html = substr($html, $found +length('"laplusgrande"'),length($html)- $found -length('"laplusgrande"'));

                         my @array = split(/"/,$html);
                         $self->{curInfo}->{boxpic} = "http://www.alapage.com" . $array[1];
                         if ( $found2 >= 0 )
                         {
                            $self->{curInfo}->{backpic} = $self->{curInfo}->{boxpic};
                            $self->{curInfo}->{backpic} =~ s|&m=r|&m=v|gi;
                         }
                   }
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"mot_hierarchie") >= 0))
            {
                $self->{isGenre} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"mot_editeur") >= 0) && ($attr->{class} eq 'greytxt'))
            {
                $self->{isEditor} = 1 ;
            }
            elsif ($tagname eq 'tpfdateparution')
            {
                $self->{isDate} = 1 ;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'edito FP_commentaire'))
            {
                $self->{isDescription} = 1 ;
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
            if ($self->{isPlatform})
            {
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//;

                $origtext =~ s/SONY //;
                $origtext =~ s/PC COMPATIBLES/PC/;

                if (($self->{itemsList}[$self->{itemIdx}]->{platform} eq '') && ($origtext ne ''))
                {
                   $self->{itemsList}[$self->{itemIdx}]->{platform} = $origtext;
                }
                elsif ($origtext ne '')
                {
                   $self->{itemsList}[$self->{itemIdx}]->{platform} .= ', ';
                   $self->{itemsList}[$self->{itemIdx}]->{platform} .= $origtext;
                }
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
                $self->{curInfo}->{name} = $origtext;
                $self->{isName} = 0 ;

                if ($self->{ean} ne '')
                {
                   $self->{curInfo}->{ean} = $self->{ean};
                }

            }
            elsif ($self->{isGenre})
            {
                # On enleve le premier element qui est le nom de la console
                my ($dummy, @array) = split(/\//,$origtext);
                my $element;
                foreach $element (@array)
                {
                   $element =~ s/^\s+//;
                   $self->{curInfo}->{genre} .= $element;
                   $self->{curInfo}->{genre} .= ",";
                }

                # Pour certains jeux le champs plteforme n est pas renseigne donc je le recupere d ici
                if (($self->{curInfo}->{platform} eq '') && ($dummy ne ''))
                {
                   $self->{curInfo}->{platform} = $dummy;
                   $self->{curInfo}->{platform} =~ s/JEUX //;
                   $self->{curInfo}->{platform} =~ s/SONY //;
                   $self->{curInfo}->{platform} =~ s/PC COMPATIBLES/PC/;
                }

                $self->{isGenre} = 0;
            }
            elsif ($self->{isEditor})
            {
                $self->{curInfo}->{editor} = $origtext;
                $self->{isEditor} = 0 ;
            }
            elsif ($self->{isPlatform})
            {
                $origtext =~ s/SONY //;
                $origtext =~ s/PC COMPATIBLES/PC/;

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
            elsif ($self->{isDate} eq 2)
            {
                $self->{curInfo}->{released} = $origtext;
                $self->{isDate} = 0 ;
            }
            elsif ($self->{isDescription} eq 2)
            {
                $self->{curInfo}->{description} .= $origtext;
                $self->{isDescription} = 0 ;
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
            genre => 0
        };

        $self->{isName} = 0;
        $self->{isGame} = 0;
        $self->{isUrl} = 0;
        $self->{isPlatform} = 0;
        $self->{isEditor} = 0;
        $self->{isDate} = 0;
        $self->{isGenre} = 0;
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
            my $found = index($html,"<!--DEBUT ARTICLE-->");
            if ( $found >= 0 )
            {
               $html = substr($html, $found +length('<!--DEBUT ARTICLE-->'),length($html)- $found -length('<!--DEBUT ARTICLE-->'));
            }
            {
                no utf8;
               $found = index($html,"<TD width=\"100%\" class=\"tx14grisbold\">&nbsp;D�posez votre avis</TD>");
            }
            if ( $found >= 0 )
            {
               $html = substr($html, 0, $found);
            }
            $html =~ s/> ISBN : </><tpfisbn><\/tpfisbn></gi;
            $html =~ s/>Date de Parution : <\//><tpfdateparution><\/tpfdateparution></gi;
            $html =~ s/>Date de parution :<\//><tpfdateparution><\/tpfdateparution></gi;
            $html =~ s|</h3>|</h3><tpfcommentaire>|gi;
            $html =~ s|<li>|\n* |gi;
            $html =~ s|<br>|\n|gi;
            $html =~ s|<br />|\n|gi;
            # Erreur sur la page d Alapage sur "HITS COLLECTION 2006"
            $html =~ s|<br<|\n|gi;
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

        if ($self->{searchField} eq 'ean')
        {
            $self->{ean} = $word;
        }
        else
        {
            $self->{ean} = '';
        }

        return 'http://www.alapage.com/mx/?tp=L&type=52&requete='.$word;
    }
    
    sub getItemUrl
    {
	my ($self, $url) = @_;

        return "http://www.alapage.com" . $url;
    }

    sub getName
    {
        return 'Alapage';
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
        return ['ean', 'name'];
    }

    sub getDefaultPictureSuffix
    {
        return '.jpg';
    }
}

1;

