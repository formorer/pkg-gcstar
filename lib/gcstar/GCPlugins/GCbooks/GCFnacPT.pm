package GCPlugins::GCbooks::GCFnacPT;

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
    package GCPlugins::GCbooks::GCPluginFnacPT;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {

            if (($tagname eq 'a') && ($attr->{class} eq 'txtpretoarial11'))
            {
                $self->{isBook} = 1 ;
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.fnac.pt" . $attr->{href};
            }
            elsif (($tagname eq 'strong') && ($self->{isBook}))
            {
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'span') && ($self->{isBook}))
            {
                $self->{isAuthor} = 1 ;
                $self->{isBook} = 0 ;
            }
        }
        else
        {
            if (($tagname eq 'span') && ($attr->{class} eq 'txtpretoarial11'))
            {
                $self->{isAnalyse} = 1 ;
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
            elsif (($tagname eq 'a') && ($attr->{class} eq 'txt_arial14'))
            {
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'strong') && ($self->{isTitle}))
            {
                $self->{isTitle} = 2 ;
            }
            elsif (($tagname eq 'a') && ($attr->{class} eq 'txt_arial10') && ( index($attr->{href},"param=autor") >= 0))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'td') && ($attr->{class} eq 'tabfundo_branco'))
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'img') && ($attr->{src} =~ m/Images\/catalogo\/livros/i))
            {
                $self->{curInfo}->{cover} = "http://www.fnac.pt" . $attr->{src};
            }
            elsif (($tagname eq 'td') && ($attr->{class} eq 'txtpretoarial11') && ($attr->{colspan} eq '2'))
            {
                $self->{isDescription} = 1 ;
            }
            elsif ($tagname eq 'object')
            {
                $self->{isDescription} = 1 ;
            }
            elsif ($tagname eq 'param')
            {
                $self->{isDescription} = 1 ;
            }
            elsif ($tagname eq 'embed')
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
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if ($self->{isTitle})
            {
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor})
            {
                my @array = split(/&/,$origtext);
                my $element;
                foreach $element (@array)
                {
                   my @nom_prenom = split(/,/,$element);
                   if ($self->{itemsList}[$self->{itemIdx}]->{authors} eq '')
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{authors} = $nom_prenom[1] ." " . $nom_prenom[0];
                   }
                   else
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{authors} .= ", " . $nom_prenom[1] ." " . $nom_prenom[0];
                   }
                }

                $self->{isAuthor} = 0 ;
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//g;
            if ($self->{isTitle} eq '1')
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor} eq 1)
            {
                if ($origtext ne '')
                {
                   my @array = split(/&/,$origtext);
                   my $element;
                   foreach $element (@array)
                   {
                      my @nom_prenom = split(/,/,$element);
                      # Enleve les blancs en debut de chaine
                      $nom_prenom[0] =~ s/^\s+//;
                      $nom_prenom[1] =~ s/^\s+//;
                      # Enleve les blancs en fin de chaine
                      $nom_prenom[0] =~ s/\s+$//;
                      $nom_prenom[1] =~ s/\s+$//;
                      if ($self->{curInfo}->{authors} eq '')
                      {
                         if ($nom_prenom[1] eq '')
                         {
                            $self->{curInfo}->{authors} = $nom_prenom[0];
                         }
                         else
                         {
                            $self->{curInfo}->{authors} = $nom_prenom[1] ." " . $nom_prenom[0];
                         }
                      }
                      else
                      {
                         if ($nom_prenom[1] eq '')
                         {
                            $self->{curInfo}->{authors} = $nom_prenom[0];
                         }
                         else
                         {
                            $self->{curInfo}->{authors} .= ", " . $nom_prenom[1] ." " . $nom_prenom[0];
                         }
                      }
                   }

                }
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isISBN} = 1 if ($origtext =~ m/ISBN/i);
                $self->{isPublisher} = 1 if ($origtext =~ m/Editora/i);
                $self->{isFormat} = 1 if ($origtext =~ m/Encaderna/i);
                $self->{isSerie} = 1 if ($origtext =~ m/Colec/i);
                $self->{isPublication} = 1 if ($origtext =~ m/Ano/i);
                $self->{isPage} = 1 if ($origtext =~ m/pages/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isISBN} eq 2)
            {
                $self->{curInfo}->{isbn} = $origtext;
                $self->{isISBN} = 0 ;
            }
            elsif ($self->{isPublisher} eq 2)
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isFormat} eq 2)
            {
                $self->{curInfo}->{format} = $origtext;
                $self->{isFormat} = 0 ;
            }
            elsif ($self->{isSerie} eq 2)
            {
                $self->{curInfo}->{serie} = $origtext;
                $self->{isSerie} = 0 ;
            }
            elsif ($self->{isPublication} eq 2)
            {
                $self->{curInfo}->{publication} = $origtext;
                $self->{isPublication} = 0 ;
            }
            elsif (($self->{isPage} eq 2))
            {
                $self->{curInfo}->{pages} = $origtext;
                $self->{isPage} = 0 ;
            }
            elsif ($self->{isDescription})
            {
                $self->{curInfo}->{description} .= $origtext;
                $self->{isDescription} = 0 ;
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
        };

        $self->{isFound} = 0;
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

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            my $found = index($html,'"listagem de resultados"');
            if ( $found >= 0 )
            {
               $html = substr($html, $found +length('"listagem de resultados"'),length($html)- $found -length('"listagem de resultados"'));
            }

            $found = index($html,'"tabela de estrutura do cart');
            if ( $found >= 0 )
            {
               $html = substr($html, 0, $found);
            }

        }
        else
        {
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
            $html =~ s|</h4>||gi;
            $html =~ s|\x{92}|'|g;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
            $html =~ s|<center>||gi;
            $html =~ s|</center>||gi;
            $html =~ s|</embed>||gi;
            $html =~ s|</object>||gi;

        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        return "http://www.fnac.pt/pt/Search/Search.aspx?categoryN=&cIndex=&catalog=livros&str=". $word;
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return $url if $url;
        return 'http://www.fnac.pt/';
    }

    sub getName
    {
        return "Fnac (PT)";
    }
    
    sub getCharset
    {
        my $self = shift;
        return "UTF-8";
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
        return ['title'];
    }
}

1;
