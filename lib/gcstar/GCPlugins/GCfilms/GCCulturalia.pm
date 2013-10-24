package GCPlugins::GCfilms::GCCulturalia;

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
#														   #
#			Plugin soumis par MeV			   #
#														   #
###################################

use strict;
use utf8;

use GCPlugins::GCfilms::GCfilmsCommon;

{
    package GCPlugins::GCfilms::GCPluginCulturalia;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if ($tagname eq "a")
            {
                if ($attr->{href} =~ /^\.\.\/art\/ver\.php\?art=/)
                {
                    my $url = $attr->{href}; 
                    $self->{isMovie} = 1;
                    $self->{isInfo} = 1;
                    $self->{itemIdx}++;
                    $self->{itemsList}[$self->{itemIdx}]->{url} = $url;
                }
            }
        }
        else
        {
            if ($tagname eq "img")
            {
                if ($attr->{src} =~ /\.\.\/(imatges\/articulos\/[0-9]*-1\.jpg)/)
                {
                    $self->{curInfo}->{image} = "http://www.culturalianet.com/" . $1;
                }
            }
            elsif ($tagname eq "font")
            {
                $self->{insideName} = 1 if $attr->{class} eq "titulo2";
                $self->{insideInfos} = 1 if $attr->{class} eq "titulo3";
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

        return if length($origtext) < 2;
           
        if ($self->{parsingList})
        {
            if ($self->{isMovie})
            {
                if ($origtext =~ /De ([^\(]*) \(([0-9]{4})\)/)
                {
                    $self->{itemsList}[$self->{itemIdx}]->{"director"} = $1;
                    $self->{itemsList}[ $self->{itemIdx} ]->{"date"}     = $2;
                    $self->{isMovie} = 0;
                    $self->{isInfo} = 1;
                }
                else
                {
                    $origtext =~ s/\.$//;
                    $self->{itemsList}[$self->{itemIdx}]->{"title"} = $origtext if !$self->{itemsList}[$self->{itemIdx}]->{"title"};
                }
                return;
            }
        }
       	else
        {
            $origtext =~ s/\s{2,}//g;
            $origtext =~ s/\n//g if !$self->{insideSynopsis};

            if ($self->{insideName})
            {
                if ($origtext =~ /([^\(]*)\. \(([0-9]{4})\)/)
                {
                    $self->{curInfo}->{title} = $1;
                    $self->{curInfo}->{date} = $2;
                }
                $self->{insideName} = 0;
            }
            elsif ($self->{insideInfos})
            {
                $origtext =~ s/ , //;
                $origtext =~ s/(, )*$//;
                if ($origtext =~ /Género\:(.*)/)
                {
                    ($self->{curInfo}->{genre} = $1) =~ s/ \/ /,/g;
                }
                elsif ($origtext =~ /Nacionalidad\:(.*)/)
                {
                    $self->{curInfo}->{country} = $1;
                }
                elsif ($origtext =~ /Director\:(.*)/)
                {
                    $self->{curInfo}->{director} = $1;
                }
                elsif ($origtext =~ /Actores\:(.*)/)
                {
                    $self->{curInfo}->{actors} = $1;
                }
                elsif ($origtext =~ /Sinopsis\:(.*)/)
                {
                    ($self->{curInfo}->{synopsis} = $1) =~ s/, //;
                }
                elsif ($origtext =~ /Duración\:(.*)/)
                {
                    ($self->{curInfo}->{time} = $1) =~ s/\.$//;
                }
                $self->{insideInfos} = 0;
            }
            elsif ($origtext =~ /^Sinopsis\:(.*)/)
            {
                ($self->{curInfo}->{synopsis} = $1) =~ s/, //;
                $self->{curInfo}->{synopsis} =~ s/(, )*$//;
            }
            if ($self->{inside}->{i})
            {
                $self->{curInfo}->{original} = $origtext;
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
            date => 1,
            director => 1,
            actors => 0,
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

        $html =~ s{</?b>}{}g;
        $html =~ s/<br>/, /g;
        $html =~ s{<a href=\.\./art/ver_e\.php\?nombre=[0-9]*>([^<]*)</a>}
                  {$1}g;
        $html =~ s{<font class.=..titulo3.>([^<]*)</font>([^<]*)}
                  {<font class ='titulo3'>$1 $2</font>}g;

        return $html;
    }
    
    sub getSearchUrl
    {
        my ($self, $word) = @_;
	
        return "http://www.culturalianet.com/bus/resu.php?texto=$word&donde=1";
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
		
        return "http://www.culturalianet.com/bus/" . $url;
    }

    sub getName
    {
        return "CulturaliaNet";
    }
    
    sub getAuthor
    {
        return 'MeV';
    }

    sub getLang
    {
        return 'ES';
    }

    sub getCharset
    {
        my $self = shift;
    
        return "Windows-1252";
    }


}

1;
