package GCPlugins::GCcomics::GCbedetheque;

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

use GCPlugins::GCcomics::GCcomicsCommon;

{

    package GCPlugins::GCcomics::GCPluginbedetheque;

    use LWP::Simple qw($ua);

    use base qw(GCPlugins::GCcomics::GCcomicsPluginsBase);
    sub getSearchUrl
    {
        my ( $self, $word ) = @_;
        if ($self->{searchField} eq 'series')
        {
            return "http://www.bedetheque.com/index.php?R=1&RechSerie=$word";
        }
        elsif ($self->{searchField} eq 'writer')
        {
            return "http://www.bedetheque.com/index.php?R=1&RechAuteur=$word";
        }
        else
        {
            return '';
        }

        #return "http://www.bedetheque.com/index.php?R=1&RechTexte=$word";
    }

    sub getSearchFieldsArray
    {
        return ['series', 'writer'];
    }

    sub getItemUrl
    {
        my ( $self, $url ) = @_;
        my @array = split( /#/, $url );
        $self->{site_internal_id} = $array[1];

        return $url if $url =~ /^http:/;
        return "http://www.bedetheque.com/" . $url;
    }

    sub getNumberPasses
    {
        return 1;
    }

    sub getName
    {
        return "Bedetheque";
    }

    sub getAuthor
    {
        return 'Mckmonster';
    }

    sub getLang
    {
        return 'FR';
    }

    sub getSearchCharset
    {
        my $self = shift;

        # Need urls to be double character encoded
        return "utf8";
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless( $self, $class );

        $self->{hasField} = {
            series => 1,
            title  => 1,
            volume => 1,
          };

        $self->{isResultsTable}   = 0;
        $self->{isCover}          = 0;
        $self->{itemIdx}          = 0;
        $self->{last_cover}       = "";
        $self->{site_internal_id} = "";
        $self->{serie}            = "";
        $self->{synopsis}         = "";
        $self->{current_field}    = "";

        return $self;
    }

    sub preProcess
    {
        my ( $self, $html ) = @_;

        $self->{parsingEnded} = 0;
        $html =~ s/\s+/ /g;
        $html =~ s/\r?\n//g;

        if ( $self->{parsingList} )
        {
            if ( $html =~ m/(\d+\salbum\(s\).+)/ ) {

                #keep only albums, no series or objects
                $html = $1;
                $self->{alternative} = 0;
            } elsif ( $html =~ m/(<div id="albums_table">.+)/ ) {
                $html = $1;
                $self->{alternative} = 1;
            }
        }
        else
        {
            $html =~ m/(<div class="box main reeditions">.+)/;

            #$html =~ m/(<div class="album.+)/;
            $html = $1;
            $self->{isResultsTable} = 0;
            $self->{parsingEnded}   = 0;
            $self->{isCover} = 0;
            $self->{itemIdx}++;;
        }

        return $html;
    }

    sub start
    {
        my ( $self, $tagname, $attr, $attrseq, $origtext ) = @_;

        return if ( $self->{parsingEnded} );

        if ( $self->{parsingList} )
        {
            if ( !defined ($self->{alternative}) || (!$self->{alternative}) )
            {
                if ( ( $tagname eq "a" ) && ( $attr->{href} =~ m/album-/ ) )
                {
                    $self->{isCollection} = 1;
                    $self->{itemIdx}++;

                    my $searchUrl =  substr($attr->{href},0,index($attr->{href},".")).substr($attr->{href},index($attr->{href},"."));
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $searchUrl;
                    $self->{itemsList}[$self->{itemIdx}]->{title} = $attr->{title};

                    #$self->{itemsList}[ $self->{itemIdx} ]->{url} =
                    #  "http://www.bedetheque.com/" . $attr->{href};
                }
                elsif ( $tagname eq "i" )
                {
                    $self->{isSerie} = 1;
                }
            } else {
                if ( ( $tagname eq "table" ) && ( $attr->{id} eq "albums_serie" ) ) {
                    $self->{inTable} = 1;
                }
                elsif ( ($self->{inTable}) && ( $tagname eq "td" ) && ( $attr->{class} eq "num" ) ) {
                    $self->{itemIdx}++;
                    $self->{isVolume} = 1;
                }
                elsif ( ($self->{inTable}) && ( $tagname eq "a" ) && ( $attr->{href} =~ m/serie-/ ) ) {
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                    $self->{isTitle} = 1;
                }
                elsif ( ( $self->{isSynopsis} ) && ( $tagname eq "br" ) && ( $self->{startSynopsis} ) ) {

      # This is a stop! for br ;-) and complementary of the p in the end section
      # should be ( ( $tagname eq "p" ) || ( $tagname eq "br" ) )
                    $self->{isSynopsis} = 0;
                    $self->{startSynopsis} = 0;
                    $self->{parsingEnded}   = 1;
                }
            }
        }
        else
        {
            if ( $tagname eq "title")
            {
                $self->{isIssue} = 1;
                $self->{isTitle} = 1;
            }

            if ( ( $self->{isCover} == 0 ) && ( $tagname eq "a" ) && ( $attr->{href} =~ m/Couvertures\/.*\.[jJ][pP][gG]/ ) )
            {
                $self->{curInfo}->{image} = 'http://www.bedetheque.com/' . $attr->{href};
                $self->{isCover} = 1;
            }
            elsif ( ( $tagname eq "div") && ( $attr->{class} eq "titre" ) ) {
                $self->{isVolume} = 1;
            }
            elsif ( ( $tagname eq "ul") && ( $attr->{class} eq "infos" ) ) {
                $self->{isResultsTable} = 1;
            }
            elsif ( ( $self->{isResultsTable} ) && ( $tagname eq "label" ) ) {
                $self->{current_field} = '';
                $self->{openlabel} = 1;
            }
            elsif ( ( $tagname eq "div" ) && ( $attr->{class} eq "title" ) && ( !defined( $self->{curInfo}->{title} ) || ( $self->{curInfo}->{title} =~ /^$/ ) ) ) {
                $self->{isTitle} = 1;
            }
            elsif ( ( $tagname eq "span" ) && ( $attr->{class} eq "type" ) ) {
                $self->{isSerie} = 1;
            }
            elsif ( $tagname eq "em" ) {
                $self->{isSynopsis} = 1;
            }
            elsif ( ( $tagname eq "a" ) && ( $attr->{class} eq "titre eo" ) ) {
                if ( $attr->{title} =~ m/.+\s-(\d+)-\s.+/ ) {
                    $self->{curInfo}->{volume} = $1;
                }
            }
        }
    }

    sub text
    {
        my ( $self, $origtext ) = @_;

        return if ( $origtext eq " " );

        return if ( $self->{parsingEnded} );

        if ( $self->{parsingList} )
        {
            if ( !defined ($self->{alternative}) || (!$self->{alternative}) ) {
                if ( $self->{isSerie} == 1)
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{series}  = $origtext;
                    $self->{isSerie} = 0;
                }
                else
                {
                    if ($self->{isCollection} == 1)
                    {

                   #sometimes the field is "-vol-title", sometimes "--vol-title"
                        $origtext =~ s/-+/-/;
                        if ( $origtext =~ m/(.+)\s-(\d+)-\s(.+)/ ) {
                            $self->{itemsList}[ $self->{itemIdx} ]->{series} = $1;
                            $self->{itemsList}[ $self->{itemIdx} ]->{volume} = $2;
                        } elsif ( $origtext =~ /-/ ){
                            my @fields = split( /-/, $origtext );
                            $self->{itemsList}[ $self->{itemIdx} ]->{series} = $fields[0];
                            $self->{itemsList}[ $self->{itemIdx} ]->{volume} = $fields[1];
                        }
                        $self->{isCollection} = 0;
                    }
                }
            } else {
                if ( ( $self->{inTable} ) && ( $self->{isTitle} ) ) {
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                } elsif ( ( $self->{inTable} ) && ( $self->{isVolume} ) ) {
                    $self->{itemsList}[ $self->{itemIdx} ]->{volume} = $origtext;
                }
            }
        }
        else
        {
            if ( $self->{isResultsTable} == 1 )
            {
                $origtext=~s/:\s+/:/;
                my %td_fields_map = (
                    "Identifiant :"   => '',
                    "Scénario :"      => 'writer',
                    "Dessin :"        => 'illustrator',
                    "Couleurs :"      => 'colourist',
                    "Dépot légal :"   => 'publishdate',
                    "Achevé impr. :"  => 'printdate ',
                    "Estimation :"    => 'cost',
                    "Editeur :"       => 'publisher',
                    "Collection : "   => 'collection',
                    "Taille :"        => 'format',
                    "ISBN :"          => 'isbn',
                    "Planches :"      => 'numberboards'
                  );

                if ( ( $self->{openlabel} ) && ( exists $td_fields_map{$origtext} ) ) {
                    $self->{current_field} = $td_fields_map{$origtext};
                }
                elsif ( defined ( $self->{current_field} ) && ( $self->{current_field} !~ /^$/ ) )
                {
                    $origtext=~s/&nbsp;/ /g;
                    $origtext=~s/\s+$//g;
                    $self->{curInfo}->{$self->{current_field}} = $origtext;
                    $self->{current_field} = "";
                }
            }
            elsif ( $self->{isVolume} )
            {
                $self->{curInfo}->{volume} = $origtext;
                $self->{isVolume} = 0 ;
            }
            
            if ( $self->{isTitle} )
            {
                $self->{curInfo}->{title} = $origtext;
            }
            elsif ( $self->{isSerie} ) {
                $self->{curInfo}->{series} = $origtext;
                $self->{curInfo}->{series} =~s/^\s+//;
            }
            elsif ( ( $self->{isSynopsis} ) && ( ( $origtext =~ /Résumé de l'album :/ ) || ( $origtext =~ /Résumé de la série :/ ) ) ) {
                $self->{startSynopsis} = 1;
            }
            elsif ( ( $self->{isSynopsis} ) && ( $self->{startSynopsis} ) ) {
                $self->{curInfo}->{synopsis} .= " ".$origtext;
                $self->{curInfo}->{synopsis} =~ s/^(\s)*//;
                $self->{curInfo}->{synopsis} =~ s/(\s)*$//;
            }
        }
    }

    sub end
    {
        my ( $self, $tagname ) = @_;

        return if ( $self->{parsingEnded} );

        if ( $self->{parsingList} )
        {
            if ( !defined ($self->{alternative}) || (!$self->{alternative}) ) {
                if ( ( $tagname eq "i" ) && $self->{isCollection} == 1)
                {

                    #end of collection, next field is title
                    $self->{isTitle}      = 1;
                    $self->{isCollection} = 0;
                }
            } else {
                if ( ( $self->{inTable} ) && ( $tagname eq "a" ) ) {
                    $self->{isTitle} = 0;
                } elsif ( ( $self->{inTable} ) && ( $tagname eq "td" ) ) {
                    $self->{isVolume} = 0;
                }
            }
        }
        else
        {
            if ( ( $tagname eq "ul" ) && $self->{isResultsTable} == 1 )
            {
                $self->{isIssue} = 0;
                $self->{isResultsTable} = 0;
            }
            elsif ( ( $self->{isResultsTable} ) && ( $tagname eq "label" ) ) {
                $self->{openlabel} = 0;
            }
            elsif ( ( $self->{isTitle} ) && ( ( $tagname eq "div" ) || ( $tagname eq "h1" ) ) ) {
                $self->{isTitle} = 0;
            }
            elsif ( ( $self->{isSerie} ) && ( $tagname eq "a" ) ) {
                $self->{isSerie} = 0;
            }
            elsif ( ( $self->{isSynopsis} ) && ( $tagname eq "em" ) && ( !$self->{startSynopsis} ) ) {
                $self->{isSynopsis} = 0;
                $self->{startSynopsis} = 0;
            }
            elsif ( ( $self->{isSynopsis} ) && ( ( $tagname eq "p" ) || ( $tagname eq "br" ) ) && ( $self->{startSynopsis} ) ) {
                $self->{isSynopsis} = 0;
                $self->{startSynopsis} = 0;
                $self->{parsingEnded}   = 1;
            }
        }
    }
}

1;