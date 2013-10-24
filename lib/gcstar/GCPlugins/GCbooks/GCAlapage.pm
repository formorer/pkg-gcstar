package GCPlugins::GCbooks::GCAlapage;

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

use GCPlugins::GCbooks::GCbooksCommon;

{
    package GCPlugins::GCbooks::GCPluginAlapage;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {

            if (($tagname eq 'div') && ($attr->{class} eq 'infos_produit'))
            {
                $self->{isBook} = 1 ;
                $self->{isUrl} = 1 ;
            }
            elsif ($tagname eq 'div')
            {
                $self->{isBook} = 0 ;
            }
            elsif (($tagname eq 'a') && ($self->{isUrl}) && ($self->{isBook}))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                $self->{itemsList}[$self->{itemIdx}]->{title} = $attr->{title};
                $self->{isUrl} = 0 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"mot_auteurs") >= 0) && ($self->{isBook}))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'br') && ($self->{isBook}))
            {
                $self->{isPublisher} = 1 ;
            }
        }
        else
        {
            if ($self->{isISBN} eq 1)
            {
                $self->{isISBN} = 2 ;
            }
            elsif ($self->{isPublication} eq 1)
            {
                $self->{isPublication} = 2 ;
            }
            elsif ($self->{isFormat} eq 1)
            {
                $self->{isFormat} = 2 ;
            }
            elsif ($self->{isPage} eq 1)
            {
                $self->{isPage} = 2 ;
            }
            elsif ($tagname eq 'h2')
            {
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'tpfcommentaire') && ($self->{isDescription} eq 1))
            {
                $self->{isDescription} = 2 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"mot_auteurs") >= 0))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{class} eq 'thickbox tooltip') && ($self->{curInfo}->{cover} eq ''))
            {
                   my $html = $self->loadPage( "http://www.alapage.com" . $attr->{href}, 0, 1);
                   my $found = index($html,"\"laplusgrande\"");
                   if ( $found >= 0 )
                   {
                      my $found2 = index($html,"&m=v");
                      $html = substr($html, $found +length('"laplusgrande"'),length($html)- $found -length('"laplusgrande"'));

                      my @array = split(/"/,$html);
                      #"
                      $self->{curInfo}->{cover} = "http://www.alapage.com" . $array[1];
                      if ( $found2 >= 0 )
                      {
                         $self->{curInfo}->{backpic} = $self->{curInfo}->{cover};
                         $self->{curInfo}->{backpic} =~ s|&m=r|&m=v|gi;
                      }
                   }
            }
            elsif ($tagname eq 'li')
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"mot_cdu") >= 0))
            {
                $self->{isGenre} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"mot_coll_serie") >= 0))
            {
                $self->{isSerie} = 1 ;
            }
            elsif (($tagname eq 'a') && ( index($attr->{href},"mot_editeur") >= 0) && ( index($attr->{href},"mot_coll_serie") == -1))
            {
                $self->{isPublisher} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{name} eq 'comment'))
            {
                $self->{isDescription} = 1 ;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'blocWithMargin') && ($self->{isDescription}) && ($self->{curInfo}->{description} eq '') )
            {
                $self->{isDescription} = 2 ;
            }
            elsif (($tagname eq 'a') && ($attr->{name} ne ''))
            {
                $self->{isDescription} = 0 ;
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
            if ($self->{isAuthor})
            {
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//;

                if ($self->{itemsList}[$self->{itemIdx}]->{authors} eq '')
                {
                   $self->{itemsList}[$self->{itemIdx}]->{authors} = $origtext;
                }
                else
                {
                   $self->{itemsList}[$self->{itemIdx}]->{authors} .= ', ';
                   $self->{itemsList}[$self->{itemIdx}]->{authors} .= $origtext;
                }
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                my @array = split(/,/,$origtext);

                $self->{itemsList}[$self->{itemIdx}]->{edition} = $array[0];
                $self->{itemsList}[$self->{itemIdx}]->{edition} =~ s/^\s+//;
                $self->{itemsList}[$self->{itemIdx}]->{edition} =~ s/\s+$//;

                if ($#array ne 0 )
                {
                   $self->{itemsList}[$self->{itemIdx}]->{publication} = $array[$#array];
                   $self->{itemsList}[$self->{itemIdx}]->{publication} =~ s/^\s+//;
                   $self->{itemsList}[$self->{itemIdx}]->{publication} =~ s/\s+$//;
                }

                $self->{isPublisher} = 0 ;
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            if ($self->{isTitle})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{curInfo}->{language} = 'Français';
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor})
            {
                $self->{curInfo}->{authors} .= $origtext;
                $self->{curInfo}->{authors} .= ",";
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isISBN} = 1 if ($origtext =~ m/ISBN/i);
                $self->{isFormat} = 1 if ($origtext =~ m/Dimensions/i);
                $self->{isPublication} = 1 if ($origtext =~ m/Date de parution/i);
                $self->{isPage} = 1 if ($origtext =~ m/Nombre de pages/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isISBN} eq 2)
            {
                $self->{curInfo}->{isbn} = $origtext;
                $self->{isISBN} = 0 ;
            }
            elsif ($self->{isGenre})
            {
                my @array = split(/,/,$origtext);
                my $element;
                foreach $element (@array)
                {
                   $element =~ s/^\s+//;
                   $self->{curInfo}->{genre} .= $element;
                   $self->{curInfo}->{genre} .= ",";
                }
                $self->{isGenre} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isSerie})
            {
                $self->{curInfo}->{serie} = $origtext;
                $self->{isSerie} = 0 ;
            }
            elsif ($self->{isFormat} eq 2)
            {
                $self->{curInfo}->{format} = $origtext;
                $self->{isFormat} = 0 ;
            }
            elsif ($self->{isPublication} eq 2)
            {
                $self->{curInfo}->{publication} = $origtext;
                $self->{isPublication} = 0 ;
            }
            elsif ($self->{isPage} eq 2)
            {
                $self->{curInfo}->{pages} = $origtext;
                $self->{isPage} = 0 ;
            }
            elsif ($self->{isDescription} eq 2)
            {
                $self->{curInfo}->{description} = $origtext;
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
            publication => 1,
            format => 0,
            edition => 1,
            serie => 0,
        };

        $self->{isBook} = 0;
        $self->{isUrl} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isPublisher} = 0;
        $self->{isAnalyse} = 0;
        $self->{isISBN} = 0;
        $self->{isGenre} = 0;
        $self->{isPublication} = 0;
        $self->{isPage} = 0;
        $self->{isFormat} = 0;
        $self->{isSerie} = 0;
        $self->{isDescription} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|<p>||gi;
            $html =~ s|</p>||gi;
        }
        else
        {
            $html =~ s|<font style=&quot;font-size:13px;&quot;>||gi;
            $html =~ s|<font style="font-size:13px;">||gi;
            $html =~ s|</font>||gi;
            $html =~ s|<strong>||gi;
            $html =~ s|</strong>|</strong><tpfanalyse>|gi;
            $html =~ s|</h3>|</h3><tpfcommentaire>|gi;
            $html =~ s|<p>||gi;
            $html =~ s|</p>||gi;
        }

        return $html;

    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        if ($self->{searchField} eq 'isbn')
        {
           return "http://www.alapage.com/-/Recherche/?type=1&mot_isbn=" . $word;
        }
        else
        {
           return "http://www.alapage.com/-/Recherche/?type=1&mot_titre=" . $word;
        }
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return "http://www.alapage.com" . $url;
    }

    sub getName
    {
        return "Alapage";
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
        return ['isbn','title'];
    }

    sub getCharset
    {
        my $self = shift;
        return "ISO-8859-15";
    }

    sub getDefaultPictureSuffix
    {
        return '.jpg';
    }
}

1;
