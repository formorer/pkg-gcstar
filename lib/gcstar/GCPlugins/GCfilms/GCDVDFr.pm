package GCPlugins::GCfilms::GCDVDFr;

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

###################################
#                                                           #
#            Plugin soumis par MeV               #
#                                                           #
###################################

use strict;
use utf8;

use GCPlugins::GCfilms::GCfilmsCommon;

{
    package GCPlugins::GCfilms::GCPluginDVDFr;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
    
        $self->{inside}->{$tagname}++;
                
        if ($self->{parsingList})
        {
            if ($tagname eq 'dvd')
            {
                my $url = $attr->{href};
                $self->{isMovie} = 1;
                $self->{isInfo} = 1;
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $url;
            }
            elsif ($tagname eq 'id')
            {
                $self->{isID} = 1;
            }
            elsif ($tagname eq 'fr')
            {
                $self->{isTitleFR} = 1;
            }
            elsif (($tagname eq 'star') && ($attr->{type} =~ /R.alisateur/))
            {
                $self->{isDirector} = 1;
            }    
            elsif ($tagname eq "media")
            {
                $self->{isMedia} = 1;
            }
            elsif ($tagname eq "edition")
            {
                $self->{isEdition} = 1;
            }
        }
        else
        {
            if (($tagname eq "cover") || ($tagname eq "jaquette"))
            {
                $self->{insideImage} = 1;
            }
            elsif ($tagname eq "url")
            {
                $self->{insideURL} = 1;
            }
            elsif (($tagname eq "fr") || ($tagname eq "titres_fr"))
            {
                $self->{insideTitleFR} = 1;
            }
            elsif (($tagname eq "vo") || ($tagname eq "titres_vo"))
            {
                $self->{insideTitleVO} = 1;
            }
            elsif ($tagname eq "pays")
            {
                $self->{insideNat} = 1;
            }
            elsif ($tagname eq "annee")
            {
                $self->{insideYear} = 1;
            }
            elsif ($tagname eq "synopsis")
            {
                $self->{insideSynopsis} = 1;
            }
            elsif ($tagname eq "duree")
            {
                $self->{insideTime} = 1;
            }
            elsif ($tagname eq "realisateur")
            {
                $self->{insideDirector} = 1;
            }
            elsif ($tagname eq "star")
            {
                $self->{insideDirector} = 1 if $attr->{type} eq "Réalisateur";
                $self->{insideActors} = 1
                    if (! $attr->{type}) || ($attr->{type} eq "Acteur");
            }
            elsif ($tagname eq "categorie")
            {
                $self->{insideGenre} = 1;
            }
            elsif ($tagname eq "rating")
            {
                $self->{curInfo}->{age} = 2 if $attr->{id} == 1;
                $self->{curInfo}->{age} = 5 if $attr->{id} == 2;
                $self->{curInfo}->{age} = 12 if $attr->{id} == 3;
                $self->{curInfo}->{age} = 13 if $attr->{id} == 4;
                $self->{curInfo}->{age} = 16 if $attr->{id} == 5;
                $self->{curInfo}->{age} = 18 if $attr->{id} > 5;
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

        return if (length($origtext) < 2) && (! $self->{isID});
           
        if ($self->{parsingList})
        {
            if ($self->{isID})
            {
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.dvdfr.com/api/dvd.php?id=$origtext";
                $self->{isID} = 0;
            }
            elsif ($self->{isDirector})
            {
                $self->{itemsList}[$self->{itemIdx}]->{"director"} .= $self->{itemsList}[$self->{itemIdx}]->{"director"} ? ", " . $origtext : $origtext
                    if ($self->{directorCounter} < $GCPlugins::GCfilms::GCfilmsCommon::MAX_DIRECTORS);
                $self->{directorCounter}++;
                $self->{isDirector} = 0;
            }
            elsif ($self->{isMovie})
            {
                $self->{itemsList}[$self->{itemIdx}]->{"title"} = $origtext;
                $self->{isMovie} = 0;
                $self->{directorCounter} = 0;
                $self->{isInfo} = 1;
                return;
            }
            elsif ($self->{isTitleFR})
            {
                $self->{itemsList}[$self->{itemIdx}]->{"title"} = $origtext;
                $self->{isTitleFR} = 0;
            }
            elsif ($self->{isMedia})
            {
                $origtext = '' if $origtext !~ /\w/;
                $self->{itemsList}[$self->{itemIdx}]->{"format"} = $origtext;
                $self->{isMedia} = 0;
            }
            elsif ($self->{isEdition})
            {
                $origtext = '' if $origtext !~ /\w/;
                $self->{itemsList}[$self->{itemIdx}]->{"extra"} = $origtext;
                $self->{isEdition} = 0;
            }
        }
        else
        {
            $origtext =~ s/\s{2,}//g;

            if ($self->{insideImage})
            {
                if ($origtext =~ m|/microapp/jaquette.php\?id=([0-9]*)|)
                {
                    my $dir = int($1 / 1000);
                    $self->{curInfo}->{image} = "http://dvdfr.com/images/dvd/cover_200x280/$dir/$1.jpg";
                }
                else
                {
                    $self->{curInfo}->{image} = $origtext;
                }
                $self->{insideImage} = 0;
            }
            elsif ($self->{insideURL})
            {
                $self->{curInfo}->{$self->{urlField}} = $origtext;
                $self->{insideURL} = 0;
            }
            elsif ($self->{insideTitleFR})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{insideTitleFR} = 0;
            }
            elsif ($self->{insideTitleVO})
            {
                $self->{curInfo}->{original} = $origtext;
                $self->{insideTitleVO} = 0;
            }
            elsif ($self->{insideNat})
            {
                $self->{curInfo}->{country} .= $self->{curInfo}->{country} ? ", " . $origtext : $origtext;
                $self->{insideNat} = 0;
            }
            elsif ($self->{insideYear})
            {
                $self->{curInfo}->{date} = $origtext;
                $self->{insideYear} = 0;
            }
            elsif ($self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} = $origtext;
                $self->{curInfo}->{synopsis} =~ s/\n/ /g;
                $self->{insideSynopsis} = 0;
            }
            elsif ($self->{insideTime})
            {
                $self->{curInfo}->{time} = $origtext;
                $self->{insideTime} = 0;
            }
            elsif ($self->{insideDirector})
            {
                $self->{curInfo}->{director} .= $self->{curInfo}->{director} ? ", " . $origtext : $origtext
                    if ($self->{directorCounter} < $GCPlugins::GCfilms::GCfilmsCommon::MAX_DIRECTORS);
                $self->{directorCounter}++;
                $self->{insideDirector} = 0;
            }
            elsif ($self->{insideActors})
            {
                $self->{curInfo}->{actors} .= $self->{curInfo}->{actors} ? ", " . $origtext : $origtext
                    if ($self->{actorsCounter} < $GCPlugins::GCfilms::GCfilmsCommon::MAX_ACTORS);
                $self->{actorsCounter}++;
                $self->{insideActors} = 0;
            }
            elsif ($self->{insideGenre})
            {
                $self->{curInfo}->{genre} .= $self->{curInfo}->{genre} ? "," . $origtext : $origtext;
                $self->{insideGenre} = 0;
            }
            elsif (($self->{inside}->{track}) && ($self->{inside}->{langue}))
            {
                if ($self->{curInfo}->{audio} !~ /(^|,)$origtext(,|$)/)
                {
                    $self->{curInfo}->{audio} .= ',' if $self->{curInfo}->{audio};
                    $self->{curInfo}->{audio} .= $origtext;
                }
            }
            elsif (($self->{inside}->{soustitrage}) && ($self->{inside}->{soustitre}))
            {
                if ($self->{curInfo}->{subt} !~ /(^|,)$origtext(,|$)/)
                {
                    $self->{curInfo}->{subt} .= ',' if $self->{curInfo}->{subt};
                    $self->{curInfo}->{subt} .= $origtext;
                }
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
            date => 0,
            director => 1,
            actors => 0,
            format => 1,
        };

        $self->{isInfo} = 0;
        $self->{isMovie} = 0;
        $self->{curName} = undef;
        $self->{curUrl} = undef;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $self->{directorCounter} = 0;
        $self->{actorsCounter} = 0;

        return $html;
    }
    
    sub getSearchUrl
    {
        my ($self, $word) = @_;
    
        $word = 'ean:'.$word
	    if $word =~ /^[\dX]{8}[\dX]*$/;

        return "http://www.dvdfr.com/api/search.php?title=$word";
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
        
        return $url unless $url eq '';
        return "http://www.dvdfr.com/";
    }

    sub changeUrl
    {
        my ($self, $url) = @_;
        
        $url =~ s/\/dvd\//\/api\//;

        return $url;
    }

    sub getName
    {
        return "DVDFr.com";
    }
    
    sub getAuthor
    {
        return 'MeV';
    }
    
    sub getLang
    {
        return 'FR';
    }

    sub getExtra
    {
        return 'Edition';
    }

    sub getEanField
    {
        return 'title';
    }

    sub isPreferred
    {
        return 1;
    }

}

1;
