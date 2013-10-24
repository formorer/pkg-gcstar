package GCPlugins::GCbooks::GCBuscape;

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
    package GCPlugins::GCbooks::GCPluginBuscape;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {

            if (($tagname eq 'a') && ($attr->{class} eq 'xu'))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                $self->{isTitle} = 1 ;
            }
            elsif (( $attr->{class} eq 'xj') && ($self->{itemIdx} eq '-1') && ($self->{searchField} eq 'isbn'))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{loadedUrl};
            }
            elsif (($tagname eq 'meta') && ($self->{itemIdx} eq '-1') && ($self->{searchField} eq 'isbn'))
            {
                my $html = $self->loadPage($self->{loadedUrl}, 0, 1);
                my $found = index($html,"URL=");
                if ( $found >= 0 )
                {
                   $html = substr($html, $found +length('URL='),length($html)- $found -length('URL='));
                   $html = substr($html, 0, index($html,"\""));
                   $self->{itemIdx}++;
                   $self->{itemsList}[$self->{itemIdx}]->{url} = $html;
                }
            }
        }
        else
        {
            if (( $attr->{class} eq 'xj') && ($self->{isAnalyse} eq 0))
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'img') && ($attr->{onerror} ne '') && ($self->{curInfo}->{title} eq ''))
            {
                # Attention il y a 2 formats differents pour ce site
                if ($attr->{alt} ne '')
                {
                   $self->{curInfo}->{title} = $attr->{alt};
                }
                if ($attr->{title} ne '')
                {
                   my @array = split(/\(/,reverse($attr->{title}));
                   my @array2;
                   if ($array[1] ne '')
                   {
                      $self->{curInfo}->{isbn} = reverse($array[0]);
                      $self->{curInfo}->{isbn} =~ s/\)//;
                      # J enleve le premier champs qui est sense etre le code ISBN
                      shift(@array);
                      my $element1;
                      my $element2;
                      foreach $element1 (@array)
                      {
                         if ($element2 eq '')
                         {
                            $element2 = $element1;
                         }
                         else
                         {
                            $element2 .= "(" .$element1;
                         }
                      }
                      @array2 = split(/-/,$element2);
                   }
                   else
                   {
                      @array2 = split(/-/,$array[0]);
                   }

                   if ($array2[1] ne '')
                   {
                      # J enleve le dernier champs qui est l auteur
                      shift(@array2);
                   }
                   my $element;
                   foreach $element (@array2)
                   {
                      if ($self->{curInfo}->{title} eq '')
                      {
                         $self->{curInfo}->{title} = $element;
                      }
                      else
                      {
                         $self->{curInfo}->{title} .= "-" .$element;
                      }
                   }
                   $self->{curInfo}->{title} = reverse($self->{curInfo}->{title});
                }

                $self->{curInfo}->{cover} = $attr->{src};
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
            if ($self->{isTitle})
            {
                my @array = split(/\(/,reverse($origtext));
                my @array2;
                if ($array[1] ne '')
                {
                   # J enleve le premier champs qui est sense etre le code ISBN
                   shift(@array);
                   my $element1;
                   my $element2;
                   foreach $element1 (@array)
                   {
                      if ($element2 eq '')
                      {
                         $element2 = $element1;
                      }
                      else
                      {
                         $element2 .= "(" .$element1;
                      }
                   }
                   @array2 = split(/-/,$element2);
                }
                else
                {
                   @array2 = split(/-/,$array[0]);
                }

                if ($array2[1] ne '')
                {
                   $self->{itemsList}[$self->{itemIdx}]->{authors} = reverse($array2[0]);
                   my $found = index($self->{itemsList}[$self->{itemIdx}]->{authors}," Cod:");
                   if ( $found >= 0 )
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{authors} = substr($self->{itemsList}[$self->{itemIdx}]->{authors}, 0, $found);
                   }
                   # Enleve les blancs en debut de chaine
                   $self->{itemsList}[$self->{itemIdx}]->{authors} =~ s/^\s+//;
                   # Enleve les blancs en fin de chaine
                   $self->{itemsList}[$self->{itemIdx}]->{authors} =~ s/\s+$//g;
                   shift(@array2);
                }
                my $element;
                foreach $element (@array2)
                {
                   if ($self->{itemsList}[$self->{itemIdx}]->{title} eq '')
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{title} = $element;
                   }
                   else
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{title} .= "-" .$element;
                   }
                }
                $self->{itemsList}[$self->{itemIdx}]->{title} = reverse($self->{itemsList}[$self->{itemIdx}]->{title});
                $self->{isTitle} = 0 ;
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//g;
            if ($self->{isAnalyse} eq 1)
            {
                if ($origtext =~ m/Autor/i)
                {
                   $self->{isAuthor} = 1 ;
                   $self->{isAnalyse} = 2 ;
                }
                elsif ($origtext =~ m/Editora/i)
                {
                   $self->{isPublisher} = 1 ;
                   $self->{isAnalyse} = 2 ;
                }
                elsif ($origtext =~ m/Ano de edi/i)
                {
                   $self->{isPublication} = 1 ;
                   $self->{isAnalyse} = 2 ;
                }
                elsif ($origtext =~ m/N.* de p.*ginas/i)
                {
                   $self->{isPage} = 1 ;
                   $self->{isAnalyse} = 2 ;
                }
                elsif ($origtext =~ m/ISBN/i)
                {
                   $self->{isISBN} = 1 ;
                   $self->{isAnalyse} = 2 ;
                }
                elsif ($origtext =~ m/Encaderna/i)
                {
                   $self->{isFormat} = 1 ;
                   $self->{isAnalyse} = 2 ;
                }
                else
                {
                   $self->{isAnalyse} = 0 ;
                }

            }
            elsif ($self->{isAuthor} eq 1)
            {
                $self->{isAuthor} = 2 ;
            }
            elsif ($self->{isAuthor} eq 2)
            {
                if ($origtext =~ m/N.*o Cadastrado/i)
                {
                }
                else
                {
                   my @nom_prenom = split(/,/,$origtext);
                   # Enleve les blancs en debut de chaine
                   $nom_prenom[0] =~ s/^\s//;
                   $nom_prenom[1] =~ s/^\s//;
                   # Enleve les blancs en fin de chaine
                   $nom_prenom[0] =~ s/\s+$//;
                   $nom_prenom[1] =~ s/\s+$//;
                   if ($self->{curInfo}->{authors} eq '')
                   {
                      if ($nom_prenom[1] ne '')
                      {
                         $self->{curInfo}->{authors} = $nom_prenom[1] ." " . $nom_prenom[0];
                      }
                      else
                      {
                         $self->{curInfo}->{authors} = $nom_prenom[0];
                      }
                   }
                   else
                   {
                      if ($nom_prenom[1] ne '')
                      {
                         $self->{curInfo}->{authors} .= ", " . $nom_prenom[1] ." " . $nom_prenom[0];
                      }
                      else
                      {
                         $self->{curInfo}->{authors} .= ", " . $nom_prenom[0];
                      }
                   }
                }

                $self->{isAuthor} = 0 ;
                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isISBN} eq 1)
            {
                $self->{isISBN} = 2 ;
            }
            elsif ($self->{isISBN} eq 2)
            {
                $self->{curInfo}->{isbn} = $origtext if ( !($origtext =~ m/N.*o Cadastrado/i) && !($origtext =~ m/n.*o dispon.*vel/i));
                $self->{isISBN} = 0 ;
                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isPublisher} eq 1)
            {
                $self->{isPublisher} = 2 ;
            }
            elsif ($self->{isPublisher} eq 2)
            {
                $self->{curInfo}->{publisher} = $origtext if ( !($origtext =~ m/N.*o Cadastrado/i) && !($origtext =~ m/n.*o dispon.*vel/i));
                $self->{isPublisher} = 0 ;
                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isPublication} eq 1)
            {
                $self->{isPublication} = 2 ;
            }
            elsif ($self->{isPublication} eq 2)
            {
                $self->{curInfo}->{publication} = $origtext if ( !($origtext =~ m/N.*o Cadastrado/i) && !($origtext =~ m/n.*o dispon.*vel/i));
                $self->{isPublication} = 0 ;
                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isPage} eq 1)
            {
                $self->{isPage} = 2 ;
            }
            elsif ($self->{isPage} eq 2)
            {
                $self->{curInfo}->{pages} = $origtext if ( !($origtext =~ m/N.*o Cadastrado/i) && !($origtext =~ m/n.*o dispon.*vel/i));
                $self->{isPage} = 0 ;
                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isFormat} eq 1)
            {
                $self->{isFormat} = 2 ;
            }
            elsif ($self->{isFormat} eq 2)
            {
                $self->{curInfo}->{format} = $origtext if ( !($origtext =~ m/N.*o Cadastrado/i) && !($origtext =~ m/n.*o dispon.*vel/i));
                $self->{isFormat} = 0 ;
                $self->{isAnalyse} = 0 ;
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
            publication => 0,
            format => 0,
            edition => 0,
            serie => 0,
        };

        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isAnalyse} = 0;
        $self->{isPublisher} = 0;
        $self->{isPublication} = 0;
        $self->{isPage} = 0;
        $self->{isISBN} = 0;
        $self->{isFormat} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|<br><i>|<i>|gi;
        }
        else
        {
            my $found = index($html,'<a name="commenti">');
            if ( $found >= 0 )
            {
               $html = substr($html, 0, $found);
            }

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
            $html =~ s|\x{92}|'|g;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;

            $html =~ s|<!--||gi;
            $html =~ s|<strong>||gi;
            $html =~ s|</strong>|<tpfnesertarien>TPFNESERTARIEN</tpfnesertarien><tpfnesertarien></tpfnesertarien>|gi;

        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        if ($self->{searchField} eq 'isbn')
        {
           return "http://compare.buscape.com.br/proc_unico?id=3482&Carac1000000000=" .$word;
        }
        else
        {
           return "http://compare.buscape.com.br/proc_unico?id=3482&Carac1000000000=" .$word;
        }

    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;

	# Attention il y a 2 formats differents pour ce site
        if ($url =~ m/counter_livro.asp/i)
        {
           my $html = $self->loadPage($url, 0, 1);
           my $found = index($html,"URL=");
           if ( $found >= 0 )
           {
              $html = substr($html, $found +length('URL='),length($html)- $found -length('URL='));
              $html = substr($html, 0, index($html,"\""));
           }
           return $html;
        }

        return $url;
    }

    sub getName
    {
        return "Buscape";
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
        return 'PT';
    }

    sub getSearchFieldsArray
    {
        return ['ISBN', 'title'];
    }
}

1;
