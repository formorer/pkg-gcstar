{
    package GCLang::GL::GCModels::GCboardgames;

    use utf8;
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
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Colección de Xogos de Mesa',
        Items => {0 => 'Xogo',
                  1 => 'Xogo',
                  X => 'Xogos'},
        NewItem => 'Novo xogo',
    
        Id => 'Id',
        Name => 'Nome',
        Original => 'Nome Orixinal',
        Box => 'Imaxe da caixa',
        DesignedBy => 'Deseñado por',
        PublishedBy => 'Publicado por',
        Players => 'Número de xogadores',
        PlayingTime => 'Tempo de xogo',
        SuggestedAge => 'Idade suxerida',
        Released => 'Publicado',
        Description => 'Descripción',
        Category => 'Categoría',
        Mechanics => 'Mecanismos',
        ExpandedBy => 'Expandido por',
        ExpansionFor => 'Expandido para',
        GameFamily => 'Familia do xogo',
        IllustratedBy => 'Ilustrado por',
        Url => 'Páxina web',
        TimesPlayed => 'Veces xogado',
        CompleteContents => 'Contidos completos',
        Copies => 'Nº de copias',
        Condition => 'Condición',
        Photos => 'Fotos',
        Photo1 => 'Primeira imaxe',
        Photo2 => 'Segunda imaxe',
        Photo3 => 'Terceira imaxe',
        Photo4 => 'Cuarta imaxe',
        Comments => 'Comentarios',

        Perfect => 'Perfecto',
        Good => 'Bo',
        Average => 'Avanzado',
        Poor => 'Pobre',

        CompleteYes => 'Contidos completos',
        CompleteNo => 'Pezas perdidas',

        General => 'Xeral',
        Details => 'Detalles',
        Personal => 'Persoal',
        Information => 'Información',

        FilterRatingSelect => 'Puntuado polo menos...',
     );
}

1;
