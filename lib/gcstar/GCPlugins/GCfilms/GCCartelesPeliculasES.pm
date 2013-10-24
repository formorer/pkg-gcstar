package GCPlugins::GCfilms::GCCartelesPeliculasES;

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
    package GCPlugins::GCfilms::GCPluginCartelesPeliculasES;

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
            # Guardamos el título
            if ($self->{inside}->{h3} && $self->{insideInfos}){
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
            }
            return;
        }
		# Codigo para el contenido de la ficha
      	else{
            # Eliminamos espacios iniciales, espacios dobles y espacios finales del texto
            $origtext =~ s/^\s*|\s{2,}|\s*$//g;
            # Estamos procesando el titulo
        	if ($self->{insideTitle})
        	{
       	  	  	$self->{curInfo}->{title} = $origtext;
                $self->{insideTitle} = 0;
				return;
		    }
			# Estamos en la puntuación
		    if ($self->{inside}->{strong} && ($origtext =~ /[0-5],[0-5][0-5]/))
		    {
				$self->{curInfo}->{rating} = ($origtext/5)*10;
				return;
			}

           # Procesamos el titulo original
            if ($self->{isOrigTit} eq 1) {
				$self->{isOrigTit} = 0;
				# Indicamos que en el siguiente paso hay que leer año,pais,duracion
                $self->{isOther} = 1;
				# Reemplazamos la primera , por # y después obtenemos el texto
				$origtext =~ s/,/#/;
				$origtext =~ s/#.*//;
				$self->{curInfo}->{original} = $origtext; 
                return;
    		}
           # Procesamos Año, pais, duracion
            if ($self->{isOther} eq 1) {
				# Comprobamos si tiene el formato de año, pais, duración
				if($origtext =~ /^(.*), (.*), (.*)$/){
	                $self->{isOther} = 0;
					$self->{curInfo}->{date} = $1;
					$self->{curInfo}->{country} = $2;
					$self->{curInfo}->{time} = $3;
				}
                return;
    		}
           # Procesamos los directores
            if ($self->{isDirector} eq 1) {
				$self->{curInfo}->{director} = $origtext;
                $self->{isDirector} = 0;
                return;
    		}
            # Actores
            if ($self->{isActors} eq 1) {
                $self->{curInfo}->{actors} = $origtext;
                $self->{isActors} = 0;
            }
            # sinopsis
            if ($self->{isSynopsis} eq 1) {
                $self->{curInfo}->{synopsis} = $origtext;
                $self->{isSynopsis} = 0;
            }

          # Condiciones para procesar los campos en el siguiente ciclo
            if($self->{inside}->{p}){
                $self->{isOrigTit} = 1 if $origtext eq "akas:";
                $self->{isDirector} =  1 if $origtext eq "Director:";
                $self->{isActors} =  1 if $origtext eq "Intérpretes:";
                $self->{isSynopsis} =  1 if $origtext eq "Sinopsis:";
				return;
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
            # Comprobamos si estamos dentro del marcador que inicia la info de un titulo
            if( ($tagname eq "h3" ) &&  ($attr->{class} eq "entry-title" )){
                # Indicamos que tenemos que se puede leer la info e incrementamos el número de resultados
                $self->{itemIdx}++;
                $self->{insideInfos} = 1 ;
				return;
            }
           # Si estamos en un título y encontramos una tag a, es un enlace a ficha
            if ($tagname eq "a" && $self->{insideInfos}){
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
				return;
            }

            if(($tagname eq "div") && ($attr->{class} eq "entry-summary" ) && $self->{insideInfos}){
                $self->{insideInfos} = 0;
				return;
            }
        }
		# Código para procesar la información de la pelicula seleccionada
        else {
		    if ($tagname eq "h1"){
                $self->{insideTitle} = 1;
				return;
            }        
		    # Si estamos dentro de una imagen y no se ha asignado ninguna, la asignamos
		    if (($tagname eq "img") &  !$self->{curInfo}->{image})
		    {
			    # Imágenes en cmg:
			    # Thumb http://www.cartelespeliculas.com/galeria/albums/003/thumbs_23p47303003.jpg
				#								 ./../../galeria/albums/005/thumbs_23p43025005.jpg
			    # Normal: http://www.cartelespeliculas.com/galeria/albums/003/23p47303003.jpg
			    # Extraemos la dirección de la imagen a partir del thumb
			    if ($attr->{src} =~ /\.\/\.\.\/\.\.\/(galeria\/albums\/[0-9]*\/)thumbs_(.*)$/)
			    {
				    $self->{curInfo}->{image} = "http://www.cartelespeliculas.com/". $1 .$2;
			    }
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
        if($html =~ /^.*Lo sentimos, no se ha encontrado.*$/s){
            $html = "";
	        return $html;
        }

        # Recorta el código del listado de resultados, quedandose solo con la parte que nos interesa del html
        # el modificador s/.../$1/s trata el flujo como una sola cadena y reemplaza todo el cuerpo con la parte que nos interesa
    	if($html =~ s/^.*<ul class="hfeed posts-default clearfix">(.*)\t<\/li>\n\t\t<\/ul>.*$/$1/s){
	        return $html;
		}

        # Recorta el código de la ficha, quedandose solo con la parte que nos interesa del html
    	if($html =~ s/^.*<div id="content" class="section">\n\n\n\n\t\t(.*)<\/li>\n<\/ul>\n<\/div>.*$/$1/s){
	        return $html;
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
        return "CartelesPeliculas";
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

		return "http://www.cartelespeliculas.com/wp/?s=" . $word;
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
            date => 0,
            director => 0,
            actors => 0
        };
        
        # Indica si estamos procesando información útil        
        $self->{insideInfos} = 0;
 
        # Indican el estado del procesado del listado de resultados
        $self->{insideTitle} = 0;

        # Indican el estado del procesado del listado de resultados (0 no procesar, 1 es el siguiente, 2 procesando)
        $self->{isOther} = 0;
        $self->{isTitle} = 0;
        $self->{isOrigTit} = 0;
        $self->{isDirector} = 0;
	    $self->{isActors} = 0;	
        $self->{isSynopsis} = 0;

        return $self;
    }

}

1;
