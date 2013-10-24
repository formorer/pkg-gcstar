package GCPlugins::GCbooks::GCLeLivre;

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
    package GCPlugins::GCbooks::GCPluginLeLivre;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {

            if (($tagname eq 'font') && ( $attr->{size} eq '-1') && ( $attr->{face} eq 'Courier New, Courier, mono') && ( $attr->{color} eq '#990000'))
            {
                $self->{itemIdx}++;
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'input') && ( $attr->{name} eq 'add'))
            {
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.le-livre.com/index.php?fich=fiche_info.php3&ref=" . $attr->{value};
            }
            elsif (($tagname eq 'font') && ( $attr->{size} eq '-1') && ( $attr->{face} eq 'Courier New, Courier, mono') && ( $attr->{color} eq '#0000CC'))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'font') && ( $attr->{size} eq '-1') && ( $attr->{face} eq 'Times New Roman, Times, serif'))
            {
                $self->{isPublisher} = 1 ;
            }
        }
        else
        {
            if ($self->{isTitle} eq 3)
            {
                $self->{isTitle} = 0 ;
                $self->{isAuthor} = 1 ;
            }
            elsif ($self->{isISBN} eq 1)
            {
                $self->{isISBN} = 2 ;
            }
            elsif ($self->{isISBN} eq 2)
            {
                $self->{isISBN} = 3 ;
            }
            elsif ($self->{isFormat} eq 1)
            {
                $self->{isFormat} = 2 ;
            }
            elsif ($self->{isFormat} eq 2)
            {
                $self->{isFormat} = 3 ;
            }
            elsif (($tagname eq 'font') && ( $attr->{color} eq '#990000') && ($self->{curInfo}->{title} eq ''))
            {
                $self->{isTitle} = 1 ;
            }
            elsif (($tagname eq 'font') && ( $attr->{size} eq '2') && ( $attr->{face} eq 'Arial, Helvetica, sans-serif') && ($self->{isTitle} eq 1))
            {
                $self->{isTitle} = 2 ;
            }
            elsif (($tagname eq 'img') && ( index($attr->{src},"/photos/") >= 0) && ($self->{curInfo}->{cover} eq ''))
            {
                $self->{curInfo}->{cover} = $attr->{src};
            }
            elsif (($tagname eq 'font') && ( $attr->{color} eq '#000099'))
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif ($tagname eq 'tpftraducteurtpf')
            {
                $self->{isTranslator} = 1 ;
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
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor})
            {
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
                $origtext =~ s|\.\.|\.|gi;
                my @array = split(/\./,$origtext);
                $self->{itemsList}[$self->{itemIdx}]->{edition} = $array[0];
                $self->{itemsList}[$self->{itemIdx}]->{publication} = $array[1];
                $self->{itemsList}[$self->{itemIdx}]->{format} = $array[2];
                $self->{isPublisher} = 0 ;
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//g;
            if ($self->{isTitle} eq 2)
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 3 ;
            }
            elsif ($self->{isAuthor})
            {
                $origtext =~ s|/ ||g;
                $self->{curInfo}->{authors} .= $origtext;
                $self->{curInfo}->{authors} .= ",";
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isTranslator})
            {
                $self->{curInfo}->{translator} = $origtext;
                $self->{isTranslator} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isISBN} = 1 if ($origtext =~ m/ISBN/i);
                $self->{isFormat} = 1 if ($origtext =~ m/Descriptif/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isFormat} eq 3)
            {
                $origtext =~ s|\.\.|\.|gi;
                my @array = split(/\./,$origtext);
                $self->{curInfo}->{publisher} = $array[0];

                # Enleve les blancs en debut de chaine
                $array[1] =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $array[1] =~ s/\s+$//g;
                $_= $array[1];
                if (/(.*)([0-9][0-9][0-9][0-9])(.*)/)
                {
                   $self->{curInfo}->{publication} = $array[1];
                }

                # Enleve les blancs en debut de chaine
                $array[2] =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $array[2] =~ s/\s+$//g;
                $self->{curInfo}->{format} = $array[2];

                my $element;
                foreach $element (@array)
                {
                   $element =~ s/^\s+//;
                   $_= $element;
                   if (/(^[0-9]+)(\s[p])(.*)/)
                   {
                      $self->{curInfo}->{pages} = $1;
                   }
                   elsif (/(^[Oo][u][v][r][a][g][e])(\s[e][n]\s)(.*)/)
                   {
                      $self->{curInfo}->{language} = $3;
                   }
                }

                $self->{isFormat} = 0 ;

            }
            elsif ($self->{isISBN} eq 3)
            {
                $self->{curInfo}->{isbn} = $origtext;
                $self->{isISBN} = 0 ;
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
            format => 1,
            edition => 1,
            serie => 0,
        };

        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isAnalyse} = 0;
        $self->{isISBN} = 0;
        $self->{isFormat} = 0;
        $self->{isTranslator} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
        }
        else
        {

            $html =~ s|: </font>|<tpfpourfaireunebalisetpf>|gi;
            $html =~ s|Traduction de |<tpftraducteurtpf>|gi;

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

        return "http://www.le-livre.com/index.php?page=1&Categ=0&mot=". $word;

    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
		
        return $url;
    }

    sub getName
    {
        return "Le-Livre";
    }
    
    sub getCharset
    {
        my $self = shift;
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
        return ['ISBN', 'title'];
    }
}

1;
