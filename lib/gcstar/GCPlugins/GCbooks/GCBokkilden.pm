package GCPlugins::GCbooks::GCBokkilden;

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
    package GCPlugins::GCbooks::GCPluginBokkilden;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingEnded})
        {
            if ($self->{itemIdx} < 0)
            {
                $self->{itemIdx} = 0;
                $self->{itemsList}[0]->{url} = $self->{loadedUrl};
            }
            return;
        }

        if ($self->{parsingList})
        {
            if (($tagname eq 'h1') && ($attr->{class} eq 'normal'))
            {
                $self->{isBook} = 1;
                $self->{itemIdx}++;
            }
            elsif ($self->{isBook})
            {
                if ($tagname eq 'a')
                {
                    if (($attr->{href} =~ /produkt\.do/)
                     && (!$self->{itemsList}[$self->{itemIdx}]->{title}))
                    {
                        $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                        $self->{isTitle} = 1;
                    }
                    elsif ($attr->{href} =~ /sok\.do\?enkeltsok/)
                    {
                        $self->{isAuthor} = 1;
                    }
                }
            }
        }
        else
        {
            if ($tagname eq 'table')
            {
                $self->{isBook} = 1
                    if ($attr->{class} eq 'bokfaktatabell');
            }
            elsif ($tagname eq 'div')
            {
                $self->{isCover} = 1 if ($attr->{class} eq 'img-ilus')
                                     && ($attr->{style} eq 'width:120px;');
                $self->{is} = 'description' if $attr->{id} eq 'omtale-hidden';
            }
            elsif ($tagname eq 'img')
            {
                if ($self->{isCover})
                {
                    $self->{curInfo}->{cover} = 'http://www.bokkilden.no/SamboWeb/'
                                              . $attr->{src};
                    $self->{isCover} = 0;
                }
            }
            elsif ($tagname eq 'h1')
            {
                $self->{h1Style} = $attr->{style};
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

        return if ($self->{parsingEnded});

        if ($self->{parsingList})
        {
            if ($self->{inside}->{title})
            {
                $self->{parsingEnded} = 1 if $origtext !~ /S..?k  p..?/;
            }

            elsif ($self->{isTitle})
            {
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                $self->{isTitle} = 0;
            }
            elsif ($self->{isAuthor})
            {
                $self->{itemsList}[$self->{itemIdx}]->{authors} .= ','
                    if $self->{itemsList}[$self->{itemIdx}]->{authors};
                $self->{itemsList}[$self->{itemIdx}]->{authors} .= $origtext;
                $self->{isAuthor} = 0;
            }
            elsif ($self->{isBook})
            {
                if ($origtext =~ / \| /)
                {
                    $origtext =~ /(\d{4})/;
                    $self->{itemsList}[$self->{itemIdx}]->{publication} = $1;
                    $self->{isBook} = 0;
                }
            }
        }
       	else
        {
             if ($self->{is})
             {
                 $origtext =~ s/^\s*//;
                 $self->{curInfo}->{$self->{is}} = $origtext;
                 if ($self->{is} eq 'genre')
                 {
                     $self->{curInfo}->{genre} =~ s/;\s*/,/g;
                 }
                 elsif ($self->{is} eq 'pages')
                 {
                     $self->{curInfo}->{pages} =~ s/[^0-9]//g;
                 }
                 $self->{is} = '';
             }
             elsif ($self->{inside}->{title})
             {
                 $self->{tmpTitle} = $origtext;
             }
             elsif ($self->{inside}->{h1})
             {
                 if (!$self->{curInfo}->{title})
                 {
                     if ($self->{h1Style})
                     {
                         $self->{tmpTitle} =~ /\s*(.*?) av (.*?) »/gim;
                         $self->{curInfo}->{title} = $1;
                         $self->{curInfo}->{authors} = $2;
                     }
                     else
                     {
                         $self->{curInfo}->{title} = $origtext;
                     }
                 }
             }
             elsif ($self->{inside}->{author})
             {
                 $self->{curInfo}->{authors} .= ','
                     if $self->{curInfo}->{authors};
                 $self->{curInfo}->{authors} .= $origtext;
             }
             if ($self->{inside}->{translator})
             {
                 $self->{curInfo}->{translator} .= ', '
                     if $self->{curInfo}->{translator};
                 $self->{curInfo}->{translator} .= $origtext;
             }
             elsif (($self->{isBook}) && $self->{inside}->{b})
             {
                 $self->{is} = 
                     ($origtext eq 'Utgitt: ') ? 'publication'
                   : ($origtext eq 'Forlag: ') ? 'publisher'
                   : ($origtext eq 'Innb.: ')  ? 'format'
                   : ($origtext =~ /Spr..?k:/) ? 'language'
                   : ($origtext eq 'Sider: ')  ? 'pages'
                   : ($origtext eq 'ISBN: ')   ? 'isbn'
                   : ($origtext eq 'Utgave: ') ? 'edition'
                   : ($origtext eq 'Genre:')  ? 'genre'
                   : '';
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
            edition => 0,
        };


        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $self->{parsingEnded} = 0;
        $self->{isBook} = 0;
        if ($self->{parsingList})
        {
            $self->{isTitle} = 0;
            $self->{isAuthor} = 0;
        }
        else
        {
            $self->{is} = '';
            $self->{isCover} = 0;
            $html =~ s|<a href="emneliste\.do\?emnekode=[.0-9]*">(.*?)</a>|$1|gim;
            $html =~ s|<a href="sok\.do\?enkeltsok=[^"]*">([^<]*)</a>|<author>$1</author>|gim;
            #"
            $html =~ s|<a href="sok\.do\?.*?rolle1=Oversetter">(.*?)</a>|<translator>$1</translator>|gim;
        }
        
        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;
        return "http://www.bokkilden.no/SamboWeb/sok.do?rom=MP&enkeltsok=$word&innsnevre=ja";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;
        return "http://www.bokkilden.no/SamboWeb/$url"
            if $url !~ m|http://www.bokkilden.no/|;
        return $url;
    }

    sub getCharset
    {
        my $self = shift;
    
        return 'UTF-8';
    }

    sub getSearchFieldsArray
    {
        return ['isbn', 'title'];
    }

    sub getName
    {
        return 'Bokkilden';
    }
    
    sub getLang
    {
        return 'NO';
    }

    sub getAuthor
    {
        return 'Tian';
    }

}

1;
