package GCPlugins::GCfilms::GCAlpacineES;

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
    package GCPlugins::GCfilms::GCPluginAlpacineES;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);


  # text
    # Called each time some plain text (between tags) is processed.
    # $origtext is the read text.
    sub text
    {
        my ($self, $origtext) = @_;

        return if length($origtext) < 2;

        # Código para procesar el resultado de la busqueda   
        if ($self->{parsingList}){
            # Guardamos la fecha.
            if ($self->{inside}->{li} && $self->{insideInfos}){
                $origtext =~ /. \(([0-9]{4})\)/;
                $self->{itemsList}[$self->{itemIdx}]->{date} = $origtext;
            }
            # Guardamos el título
            if ($self->{inside}->{a} && $self->{insideInfos}){
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
            }
        }
	
       	else{
            # Eliminamos espacios iniciales, espacios dobles y espacios finales del texto
            $origtext =~ s/^\s*|\s{2,}|\s*$//g;
            # Estamos procesando el titulo
        	if ($self->{insideTitle})
        	{
                # Obtenemos titulo y fecha
                $origtext =~ /(.*) \(([0-9]{4})\)/;
       	  	  	$self->{curInfo}->{title} = $1;
       	  	  	$self->{curInfo}->{date} = $2;
                $self->{insideTitle} = 0;
				return;
		    }

            # Si existe el hipervinculo "Ampliar" cambiamos la imagen por la ampliada
            if ($self->{inside}->{a} && $origtext eq "Ampliar"){
                $self->{curInfo}->{image}  =~ /(http:\/\/img.alpacine.com\/carteles\/.*)-[0-9]*(\.jpg)/;
			    $self->{curInfo}->{image} = $1 . $2;
				return;
            }
            # Estamos en la puntuación real
            if($self->{insideRating}){
                $self->{curInfo}->{ratingpress} = int( $origtext + 0.5 );
                $self->{insideRating} = 0;
            }
            # No hay puntuación real, asignamos 0 por defecto
            if($self->{inside}->{div}){
                if($origtext =~ /Esperando \d votos/){
                    $self->{curInfo}->{ratingpress} = 0;
                }
            }
            # Procesamos el titulo original
            if ($self->{isOrigTit} eq 1) {
                $self->{isOrigTit} = 0;
                $self->{curInfo}->{original} = $origtext;
                return;
    		}
            # Procesamos los generos (gen, gen, gen, gen...)
            if ($self->{isGenres} eq 1) {
                if($origtext ne ""){
                    # hacemos uso de sus propias comas
                    $self->{curInfo}->{genre} .= $origtext;
                }
                else{
                    $self->{isGenres} = 0;
                }
                return;
    		}
            # Procesamos el país
            if ($self->{isCountry} eq 1) {
                $self->{isCountry} = 0;
                $self->{curInfo}->{country} = $origtext;
                return;
    		}
            # Procesamos la duración
            if ($self->{isTime} eq 1) {
                $self->{isTime} = 0;
                $self->{curInfo}->{time} = $origtext;
                return;
    		}
            # Procesamos los directores
            if ($self->{isDirector} eq 1) {
                if($origtext ne ""){
                    if($self->{curInfo}->{director} eq ""){
                        $self->{curInfo}->{director} .= $origtext;
                    }
                    else{
                        $self->{curInfo}->{director} .= ", $origtext";
                    }
                }
                else{
                    $self->{isDirector} = 0;
                }
                return;
    		}
            # Actores
            if ($self->{isActors} eq 1) {
                if($origtext ne ""){
                    if($self->{curInfo}->{actors} eq ""){
                        $self->{curInfo}->{actors} .= $origtext;
                    }
                    else{
                        $self->{curInfo}->{actors} .= ", $origtext";
                    }
                }
                else{
                    $self->{isActors} = 0;
                }
                return;
            }
            # Procesamos la Sinopsis
            if ($self->{isSynopsis} eq 1) {
                $self->{isSynopsis} = 0;
                $self->{curInfo}->{synopsis} = $origtext;
                return;
    		}
            # Procesamos los premios
            if ($self->{isAwards} eq 1) {
                $self->{isAwards} = 0;
                $self->{curInfo}->{synopsis} = $self->{curInfo}->{synopsis}. "\n\nPremios:\n\t".$origtext;
                $self->{insideInfos} = 0;
                return;
    		}

            # Condiciones para procesar los campos en el siguiente ciclo
            if($self->{insideInfos}){
                $self->{isOrigTit} = 1 if $origtext eq "Título original:";
                $self->{isGenres} =  1 if $origtext eq "Género:";
                $self->{isCountry} =  1 if $origtext eq "País:";
                $self->{isTime} =  1 if $origtext eq "Duración:";
                $self->{isDirector} =  1 if $origtext eq "Dirección:";
                $self->{isActors} =  1 if $origtext eq "Interpretación:";
                $self->{isSynopsis} =  1 if $origtext eq "Sinopsis:";
				$self->{isAwards} = 1 if $origtext eq "Premios:";
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
            # Comprobamos si estamos dentro de un título utilizando el atributo class
            if( ($tagname eq "li" ) &&  ($attr->{class} ne "mas" )){
                $self->{itemIdx}++;
                $self->{insideInfos} = 1 ;
				return;
            }
            if( ($tagname eq "li" ) &&  ($attr->{class} eq "mas" )){
                $self->{insideInfos} = 0;
				return;
            }
            # Si estamos en un título y encontramos una tag a, es un enlace a ficha
            if ($tagname eq "a" && $self->{insideInfos}){
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.alpacine.com".$attr->{href};
				return;
            }
        }
	# Código para procesar la información de la pelicula seleccionada
        else {
		    if ($tagname eq "h1"){
                $self->{insideTitle} = 1;
				return;
            }        
		    # Si estamos dentro de una imagen y el src es el del thumb lo asignamos como imagen
		    if ($tagname eq "img")
		    {
			    # Extraemos la dirección de la imagen thumb
			    if ($attr->{src} =~ /http:\/\/img.alpacine.com\/carteles\/.*\.jpg/)
			    {
				    $self->{curInfo}->{image} = $attr->{src};
			    }
				return;
		    }

		    if ($tagname eq "div" && $attr->{class} eq "voto"){
                $self->{insideRating} = 1;
				return;
            }        
            
            if( $tagname eq "div"  &&  $attr->{class} eq "datos" ){
                $self->{insideInfos} = 1 ;
                return;
            }
        }
    }

    # preProcess
    # Called before each page is processed. You can use it to do some substitutions.
    # $html is the page content.
    # Returns modified version of page content.
    sub preProcess
    {
        my ($self, $html) = @_;

        # Anulamos el html si coincide con el patron de no resultados
        if($html =~ /^.*No hay resultados para.*$/s){
            $html = "";
			return $html;
        }

        # Recorta el código del listado de resultados, quedandose solo con la parte que nos interesa del html
        # el modificador s/.../$1/s trata el flujo como una sola cadena y reemplaza todo el cuerpo con la parte que nos interesa
		if($html =~ s/^.*<div class="titulo">Pel.culas <span class="resultados">\([0-9]* resultado[s]?\)<\/span><\/div><ul>(<li><a.*<\/a> \([0-9]*\)<\/li>).*$/$1/s){
			return $html;
		}

        # Recorta el código de la ficha, quedandose solo con la parte que nos interesa del html
		# Comprobamos si la pelicula contiene o no premios y nos quedamos con lo que corresponda
		if($html =~ /^.*<div class="titulo">Premios:.*más\.\.\.<\/a><\/div><\/div>.*$/s){
			$html =~ s/^.*<div id="titulo">(.*<\/div><\/div>.*\n.*<div class="datox"><div class="titulo">Premios:.*)más\.\.\.<\/a><\/div><\/div>.*$/$1/s;
		}
		else{
			$html =~ s/^.*<div id="titulo">(.*<\/div><\/div>)\n\n\t\t\t\t\n\n\t\t\t\t<hr \/>.*$/$1/s;			
		}
		return $html;
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
        return 'Alpacine';
    }


    # getCharset
    # Used to convert charset in web pages.
    # Returns the charset as specified in pages.
    #sub getCharset
    #{
    #    my $self = shift;
    #    # Charset de la web
    #    return "UTF-8";
    #}


    # getItemUrl
    # Used to get the full URL of an item page.
    # Useful when url on results pages are relative.
    # $url is the URL as found with a search.
    # Returns the absolute URL.    
    sub getItemUrl
    {
	    my ($self, $url) = @_;
        return $url;
    }


    # getSearchUrl
    # Used to get the URL that to be used to perform searches.
    # $word is the query
    # Returns the full URL.    
    sub getSearchUrl
    {
    	my ($self, $word) = @_;
		# Hack para evitar problemas con acentos
		$word =~ s/%E1/a/g;
		$word =~ s/%E9/e/g;
		$word =~ s/%ED/i/g;
		$word =~ s/%F3/o/g;
		$word =~ s/%FA/u/g;
		$word =~ s/%C1/A/g;
		$word =~ s/%C9/E/g;
		$word =~ s/%CD/I/g;
		$word =~ s/%D3/O/g;
		$word =~ s/%DA/U/g;

        return "http://www.alpacine.com/buscar/?buscar=" . $word;

    }


   # Constructor
    sub new
    {
	# Inicialización
        my $proto = shift;
        my $class = ref($proto)  ||  $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        # Campos que devuelve el plugin (1 si, 0 no). Son los que apareceran
        # en el listado de resultados
        $self->{hasField} = {
            title => 1,
            date => 1,
            director => 0,
            actors => 0,
        };
        
        # Indica si estamos procesando información útil        
        $self->{insideInfos} = 0;

        # Indican el estado del procesado del listado de resultados
        $self->{insideRating} = 0;
        $self->{insideTitle} = 0;

        $self->{isOrigTit} = 0;
        $self->{isGenres} = 0;
        $self->{isCountry} = 0;
        $self->{isTime} = 0;
        $self->{isDirector} = 0;
        $self->{isActors} = 0;
        $self->{isSynopsis} = 0;
        $self->{isAwards} = 0;

        return $self;
    }

}

1;
