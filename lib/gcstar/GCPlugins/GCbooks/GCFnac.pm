package GCPlugins::GCbooks::GCFnac;

###################################################
#
#  Copyright 2005-2006 Tian
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

use GCPlugins::GCbooks::GCbooksCommon;

{
    package GCPlugins::GCbooks::GCPluginFnac;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            return if $self->{isFound};
            if (($tagname eq 'h3') && ($attr->{class} eq 'hStyle1'))
            {
                $self->{isFound} = 1 ;
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{loadedUrl};
                return;
            }
            elsif ($tagname eq 'td')
            {
                if (($attr->{width} eq '254') && (!exists $attr->{bgcolor}))
                {
                    $self->{isBook} = 1 ;
                    $self->{isUrl} = 1 ;
                    $self->{isColonne} = 0 ;
                }
                else
                {
                    $self->{isColonne} ++ ;
                    $self->{isTitle} = 2 ;
                }
            }
            elsif (($attr->{class} eq 'subTitre') && (!exists $attr->{color}) && ($self->{isTitle} eq '0'))
            {
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'tpfpublicationtpf') && ($self->{isBook}))
            {
                $self->{isPublication} = 1 ;
            }
            elsif (($tagname eq 'a') && ($self->{isBook}))
            {
                if ($attr->{href} =~ m|/advanced/book.do\?category=book|i)
                {
                    $self->{isBook} = 0 ;
                    $self->{isUrl} = 0 ;
                }
                elsif ($self->{isUrl})
                {
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                    $self->{isTitle} = 1 ;
                    $self->{isUrl} = 0 ;
                }
                elsif ($self->{isColonne} eq 2)
                {
                    $self->{isAuthor} = 1 ;
                }
                elsif ($self->{isColonne} eq 4)
                {
                    $self->{isPublisher} = 1 ;
                }
            }
        }
        else
        {
            if ($tagname eq 'tr')
            {
                $self->{isAuthor} = 0 ;
                $self->{isISBN} = 0 ;
                $self->{isPublisher} = 0 ;
                $self->{isFormat} = 0 ;
                $self->{isSerie} = 0 ;
                $self->{isPublication} = 0 ;
                $self->{isPage} = 0 ;
                $self->{isTranslator} = 0 ;
            }
            elsif ($self->{isAuthor} eq 1)
            {
                $self->{isAuthor} = 2 ;
            }
            elsif ($self->{isISBN} eq 1)
            {
                $self->{isISBN} = 2 ;
            }
            elsif ($self->{isPublisher} eq 1)
            {
                $self->{isPublisher} = 2 ;
            }
            elsif ($self->{isFormat} eq 1)
            {
                $self->{isFormat} = 2 ;
            }
            elsif ($self->{isSerie} eq 1)
            {
                $self->{isSerie} = 2 ;
            }
            elsif ($self->{isPublication} eq 1)
            {
                $self->{isPublication} = 2 ;
            }
            elsif ($self->{isPage} eq 1)
            {
                $self->{isPage} = 2 ;
            }
            elsif ($self->{isTranslator} eq 1)
            {
                $self->{isTranslator} = 2 ;
            }
            elsif (($tagname eq 'h3') && ($attr->{class} eq 'hStyle1'))
            {
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'strong') && (($self->{isTitle}) || $attr->{class} eq 'titre dispeblock'))
            {
                $self->{isTitle} = 2 ;
            }
            elsif (($tagname eq 'th') && ($attr->{scope} eq 'row'))
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{class} eq 'expandimg') && ($self->{bigPics}))
            {
                $self->{curInfo}->{cover} = $attr->{href} ;
            }
            elsif (($attr->{class} eq 'activeimg') && ((!$self->{bigPics}) || ($self->{curInfo}->{cover} eq '')))
            {
                $self->{isCover} = 1 ;
            }
            elsif (($tagname eq 'img') && ($self->{isCover}))
            {
                $self->{curInfo}->{cover} = $attr->{src} ;
                $self->{isCover} = 0 ;
            }
            elsif (($tagname eq 'div') && ($attr->{class} =~ /^lireLaSuite/))
            {
                $self->{isDescription} = 1 ;
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;

        $self->{isFound} = 0 ;
        $self->{inside}->{$tagname}--;
        $self->{isDescription} = 0 if $tagname eq 'div';
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if ($self->{isTitle} eq 1)
            {
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//g;
                if (($self->{itemsList}[$self->{itemIdx}]->{title} eq '') && ($origtext ne ''))
                {
                   $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                }
                elsif ($origtext ne '')
                {
                   $self->{itemsList}[$self->{itemIdx}]->{title} .= ' - ';
                   $self->{itemsList}[$self->{itemIdx}]->{title} .= $origtext;
                }
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor})
            {
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//g;
                if (($self->{itemsList}[$self->{itemIdx}]->{authors} eq '') && ($origtext ne ''))
                {
                   $self->{itemsList}[$self->{itemIdx}]->{authors} = $origtext;
                }
                elsif ($origtext ne '')
                {
                   $self->{itemsList}[$self->{itemIdx}]->{authors} .= ', ';
                   $self->{itemsList}[$self->{itemIdx}]->{authors} .= $origtext;
                }
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                $self->{itemsList}[$self->{itemIdx}]->{edition} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isPublication})
            {
                $self->{itemsList}[$self->{itemIdx}]->{publication} = $origtext;
                $self->{isPublication} = 0 ;
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//g;
            if ($self->{isTitle} eq '2')
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isAuthor} = 1 if ($origtext =~ m/Auteur/i);
                $self->{isISBN} = 1 if ($origtext =~ m/ISBN/i);
                $self->{isPublisher} = 1 if ($origtext =~ m/Editeur/i);
                $self->{isFormat} = 1 if ($origtext =~ m/Format/i);
                $self->{isSerie} = 1 if ($origtext =~ m/Collection/i);
                $self->{isPublication} = 1 if ($origtext =~ m/Date de parution/i);
                $self->{isPage} = 1 if ($origtext =~ m/pages/i);
                $self->{isTranslator} = 1 if ($origtext =~ m/Traduction/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isAuthor} eq 2)
            {
                # Enleve les virgules
                $origtext =~ s/,//;
                if ($origtext ne '')
                {
                   $self->{curInfo}->{authors} .= $origtext;
                   $self->{curInfo}->{authors} .= ",";
                }
            }
            elsif ($self->{isISBN} eq 2)
            {
                $self->{curInfo}->{isbn} = $origtext;
                $self->{isISBN} = 0 ;
            }
            elsif ($self->{isPublisher} eq 2)
            {
                if ($origtext ne '')
                {
                   $self->{curInfo}->{publisher} = $origtext;
                   $self->{isPublisher} = 0 ;
                }
            }
            elsif ($self->{isFormat} eq 2)
            {
                if ($origtext ne '')
                {
                   $self->{curInfo}->{format} = $origtext;
                   $self->{isFormat} = 0 ;
                }
            }
            elsif ($self->{isSerie} eq 2)
            {
                if ($origtext ne '')
                {
                   $self->{curInfo}->{serie} = $origtext;
                   $self->{isSerie} = 0 ;
                }
            }
            elsif ($self->{isPublication} eq 2)
            {
                if ($origtext ne '')
                {
                   $self->{curInfo}->{publication} = $origtext;
                   $self->{isPublication} = 0 ;
                }
            }
            elsif (($self->{isPage} eq 2))
            {
                if ($origtext ne '')
                {
                   $self->{curInfo}->{pages} = $origtext;
                   $self->{isPage} = 0 ;
                }
            }
            elsif ($self->{isTranslator})
            {
                if ($origtext ne '')
                {
                   $self->{curInfo}->{translator} = $origtext;
                   $self->{isTranslator} = 0 ;
                }
            }
            elsif ($self->{isDescription})
            {
                $self->{curInfo}->{description} .= $origtext;
            }

        }
    } 

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            title => 1,
            authors => 1,
            publication => 1,
            format => 0,
            edition => 1,
            serie => 0,
        };

        $self->{isFound} = 0;
        $self->{isColonne} = 0;
        $self->{isBook} = 0;
        $self->{isUrl} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isPublisher} = 0;
        $self->{isISBN} = 0;
        $self->{isPublication} = 0;
        $self->{isFormat} = 0;
        $self->{isSerie} = 0;
        $self->{isPage} = 0;
        $self->{isDescription} = 0;
        $self->{isCover} = 0;
        $self->{isTranslator} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|</a><br>|</a><tpfpublicationtpf>|gmi;
        }
        else
        {
            # Le descriptif pouvant contenir des balises html je le repere maintenant
            my $found = index($html,"<strong>Mot de l'");
            if ( $found >= 0 )
            {
               my $html2 = substr($html, $found +length('<strong>Mot de l\''),length($html)- $found -length('<strong>Mot de l\''));
               my $found2 = index($html2,"<h4 ");
               my $html3 = $html2;
               if ( $found2 >= 0 )
               {
                  $html3 = substr($html2, $found2 +length('<h4 '),length($html2)- $found2 -length('<h4 '));
                  $html2 = substr($html2, 0, $found2);
               }

               $found2 = index($html2,"</strong>");
               if ( $found2 >= 0 )
               {
                  $html2 = substr($html2, $found2 +length('</strong>'),length($html2)- $found2 -length('</strong>'));
               }

               $html2 =~ s|<li>|\n* |gi;
               $html2 =~ s|<br>|\n|gi;
               $html2 =~ s|<br />|\n|gi;
               $html2 =~ s|<b>||gi;
               $html2 =~ s|</b>||gi;
               $html2 =~ s|<i>||gi;
               $html2 =~ s|</i>||gi;
               $html2 =~ s|<p>|\n|gi;
               $html2 =~ s|</p>||gi;
               $html2 =~ s|</h4>||gi;
               $html2 =~ s|\x{92}|'|g;
               $html2 =~ s|&#146;|'|gi;
               $html2 =~ s|&#149;|*|gi;
               $html2 =~ s|&#133;|...|gi;
               $html2 =~ s|\x{85}|...|gi;
               $html2 =~ s|\x{8C}|OE|gi;
               $html2 =~ s|\x{9C}|oe|gi;

            }

        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
        my ($self, $word) = @_;
	
        return "http://www3.fnac.com/search/quick.do?filter=-3&text=". $word ."&category=book";
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
		
        return $url if $url;
        return 'http://www.fnac.com/';
    }

    sub getName
    {
        return "Fnac (FR)";
    }
    
    sub getCharset
    {
        my $self = shift;
        return "ISO-8859-15";
#        return "UTF-8";
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
        return ['isbn', 'title'];
    }
}

1;
