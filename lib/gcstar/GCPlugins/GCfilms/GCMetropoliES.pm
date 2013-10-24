package GCPlugins::GCfilms::GCMetropoliES;

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

use GCPlugins::GCfilms::GCfilmsCommon;

{

    package GCPlugins::GCfilms::GCPluginMetropoliES;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);

    # preProcess
    # Called before each page is processed. You can use it to do some substitutions.
    # $html is the page content.
    # Returns modified version of page content.
    sub preProcess
    {
        my ($self, $html) = @_;

# Recorta el código del listado de resultados, quedandose solo con la parte que nos interesa del html
# el modificador s/.../$1/s trata el flujo como una sola cadena y reemplaza todo el cuerpo con la parte que nos interesa
        $html =~ s/^.*(<table width="100%"  border="0" cellspacing="0" cellpadding="5">.*<\/td>\n  <\/tr>\n<\/table>)\n\n\n.*$/$1/gs;

        # Recorta el código de la ficha, quedandose solo con la parte que nos interesa del html
        $html =~ s/^.*(<table width="100%"  border="0" cellspacing="0" cellpadding="5">.*<\/td>\n  <\/tr>\n<\/table>)\n<table.*$/$1/gs;
        return $html;
    }

    # text
    # Called each time some plain text (between tags) is processed.
    # $origtext is the read text.
    sub text
    {
        my ($self, $origtext) = @_;

        return if length($origtext) < 2;

        # Código para procesar el resultado de la busqueda
        if ($self->{parsingList})
        {
            if ($self->{isDate} eq 2)
            {
                $self->{isDate}                                = 0;
                $self->{itemsList}[ $self->{itemIdx} ]->{date} = $origtext;
                $self->{isTitle}                               = 1;
                return;
            }

            if ($self->{isTitle} eq 2)
            {
                $self->{isTitle}                                = 0;
                $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                $self->{isOrigTit}                              = 1;
                return;
            }
            if ($self->{isOrigTit} eq 2)
            {
                $self->{isOrigTit}  = 0;
                $self->{isDirector} = 1;
                return;
            }

            if ($self->{isDirector} eq 2)
            {
                $self->{isDirector}                                = 0;
                $self->{itemsList}[ $self->{itemIdx} ]->{director} = $origtext;
                $self->{insedeInfos}                               = 0;
                return;
            }
            return;
        }

        else
        {
            $origtext =~ s/\s{2,}//g;
            #$origtext =~ s/\n//g if !$self->{insideSynopsis};
            if ($self->{insideName})
            {
                if ($origtext =~ /([^\(]*) \(([0-9]{4})\)/)
                {
                    $self->{curInfo}->{title} = $1;
                    $self->{curInfo}->{date}  = $2;
                }
                $self->{insideName} = 0;
            }
            if ($self->{inside}->{td})
            {
                if ($origtext =~ /(.*), (.*), (.*) Min\./)
                {
                    $self->{curInfo}->{original} = $1;
                    $self->{curInfo}->{country}  = $2;
                    $self->{curInfo}->{time}     = $3;
                }
                elsif ($self->{insideActors})
                {
                    $self->{insideActors}--;
                    if ($self->{insideActors} eq 0)
                    {
                        $self->{insideActors} = 0;
                        $self->{curInfo}->{actors} = $origtext;
                    }
                }
            }
            if ($self->{insideDirector})
            {
                $self->{insideDirector} = 0;
                $self->{curInfo}->{director} = $origtext;
            }

            if ($self->{inside}->{span})
            {
                if ($origtext =~ /Int.rpretes:/)
                {
                    $self->{insideActors} = 2;
                }
            }
            if ($self->{insideSynopsis})
            {
                $self->{curInfo}->{synopsis} = $origtext;
                $self->{insideSynopsis}      = 0;
                $self->{insideInfos}         = 0;
            }
        }
    }

    # end
    # Called each time a HTML tag ends.
    # $tagname is the tag name.
    sub end
    {
        my ($self, $tagname) = @_;
        $self->{inside}->{$tagname}--;

        # Código para procesar el resultado de la busqueda
        #if ($self->{parsingList}){
        #}
        # Código para procesar la información de la pelicula seleccionada
        #else {
        #}
    }

    # In processing functions below, self->{parsingList} can be used.
    # If true, we are processing a search results page
    # If false, we are processing a item information page.

    # $self->{inside}->{tagname} (with correct value for tagname) can be used to test
    # if we are in the corresponding tag.

    # You have a counter $self->{itemIdx} that have to be used when processing search results.
    # It is your responsability to increment it!

    # When processing search results, you have to fill the available fields for results
    #
    #  $self->{itemsList}[$self->{movieIdx}]->{field_name}
    #
    # When processing a movie page, you need to fill the fields (if available)
    # in $self->{curInfo}.
    #
    #  $self->{curInfo}->{field_name}

    # start
    # Called each time a new HTML tag begins.
    # $tagname is the tag name.
    # $attr is reference to an associative array of tag attributes.
    # $attrseq is an array reference containing all the attributes name.
    # $origtext is the tag text as found in source file
    # Returns nothing
    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
        $self->{inside}->{$tagname}++;

        # Código para procesar el resultado de la busqueda para generar el listado
        if ($self->{parsingList})
        {
            # Comprobamos si estamos dentro de un tr con la info de un titulo
            if (($tagname eq "tr") && (($attr->{bgcolor} eq "#ECF5FF") || ($attr->{bgcolor} eq "#FFFFFF")))
            {
                $self->{insideInfos} = 1;
                # Lo primero a leer es la fecha. Indicamos que es el siguiente a procesar
                $self->{isDate}     = 1;
                $self->{isTitle}    = 0;
                $self->{isOrigTit}  = 0;
                $self->{isDirector} = 0;
                # Aumentamos el número de resultados encontrados
                $self->{itemIdx}++;
                return;
            }

            # Comprobamos que campo de la información estamos pocesando
            if ($tagname eq "td" && $self->{insideInfos})
            {
                $self->{isDate}     = 2 if $self->{isDate}     eq 1;
                $self->{isOrigTit}  = 2 if $self->{isOrigTit}  eq 1;
                $self->{isDirector} = 2 if $self->{isDirector} eq 1;
            }
            if ($tagname eq "a" && $self->{isTitle})
            {
                $self->{isTitle} = 2;
                # Guardamos la Url del enlace
                my $url = $attr->{href};
                $self->{itemsList}[ $self->{itemIdx} ]->{url} = $url;
            }
        }
        # Código para procesar la información de la pelicula seleccionada
        else
        {
            # Si estamos dentro de una imagen y no se ha asignado ninguna, la asignamos
            if (($tagname eq "img") & !$self->{curInfo}->{image})
            {
# Imágenes en cmg:
# Thumb http://carteles.metropoliglobal.com/galerias/data/1149/1563-2008-rastrooculto-espanol-210459-thumb.jpg
# Normal: http://carteles.metropoliglobal.com/galerias/data/1149/1563-2008-rastrooculto-espanol-210459.jpg
# Extraemos la dirección de la imagen a partir del thumb
                if ($attr->{src} =~ /\.\.\/(galerias\/data\/[0-9]*\/.*)-thumb\.jpg/)
                {
                    $self->{curInfo}->{image} = "http://carteles.metropoliglobal.com/" . $1 . ".jpg";
                }
            }

            # Comprobamos el rating
            if ($tagname eq "img")
            {
                # En cmg la puntuación está asignada con una imagen con el formato ratingX.gif donde
                # X está entre 0 y 5
                if ($attr->{src} =~ /imagenes\/rating([0-5])\.gif/)
                {
                    $self->{curInfo}->{ratingpress} = ($1 / 5) * 10;
                }
            }
            elsif ($tagname eq "span")
            {
                $self->{insideName}  = 1 if $attr->{class} eq "title";
                $self->{insideInfos} = 1 if $attr->{class} eq "title";
            }
            elsif ($tagname eq "td")
            {
                $self->{insideDirector} = 1 if $attr->{width} eq "84%";
                if ($self->{insideInfos})
                {
                    $self->{insideSynopsis} = 1 if $attr->{colspan} eq "2";
                }
            }
        }
    }

    # changeUrl
    # Can be used to change URL if item URL and the one used to
    # extract information are different.
    # Return the modified URL.
    #sub changeUrl
    #{
    #  my ($self, $url) = @_;
    #        return $url;
    #}

    # getExtra
    # Used if the plugin wants an extra column to be displayed in search results
    # Return the column title or empty string to hide the column.
    #sub getExtra
    #{
    #   return 'Extra';
    #}

    # getLang
    # Used to fill in plugin list with user language plugins
    # Return the language used for this site (2 letters code).
    sub getLang
    {
        return "ES";
    }

    # getAuthor
    # Used to display the plugin author in GUI.
    # Returns the plugin author name.
    sub getAuthor
    {
        return "DoVerMan";
    }

    # getName
    # Used to display plugin name in GUI.
    # Returns the plugin name.
    sub getName
    {
        return 'CartelesMetropoliGlobal';
    }

    # getCharset
    # Used to convert charset in web pages.
    # Returns the charset as specified in pages.
    sub getCharset
    {
        my $self = shift;
        # Charset de la web
        return "iso-8859-1";
    }

    # getItemUrl
    # Used to get the full URL of an item page.
    # Useful when url on results pages are relative.
    # $url is the URL as found with a search.
    # Returns the absolute URL.
    sub getItemUrl
    {
        my ($self, $url) = @_;
        # url contendrá ficha.php?......

        return "http://carteles.metropoliglobal.com/paginas/$url";
    }

    # getSearchUrl
    # Used to get the URL that to be used to perform searches.
    # $word is the query
    # Returns the full URL.
    sub getSearchUrl
    {
        my ($self, $word) = @_;
        return "http://carteles.metropoliglobal.com/paginas/ficha.php"
          . "?qbtitulo=$word&qbbuscar=titulo&Submit=Buscar&qsec=buscar";
    }

    # Constructor
    sub new
    {
        # Inicialización
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless($self, $class);

        # Campos que devuelve el plugin (1 si, 0 no). Son los que apareceran
        # en el listado de resultados
        $self->{hasField} = {
            title    => 1,
            date     => 1,
            director => 1,
            actors   => 0,
        };

        # Indica si estamos procesando información útil
        $self->{insideInfos} = 0;

  # Indican el estado del procesado del listado de resultados (0 no procesar, 1 es el siguiente, 2 procesando)
        $self->{isDate}     = 0;
        $self->{isTitle}    = 0;
        $self->{isOrigTit}  = 0;
        $self->{isDirector} = 0;

        $self->{curName} = undef;
        $self->{curUrl}  = undef;

        return $self;
    }

}

1;
