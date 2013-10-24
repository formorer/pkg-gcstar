{
    package GCLang::CA::GCModels::GCsoftware;

    use utf8;
###################################################
#
#  Copyright 2005-2009 Tian
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
    
        CollectionDescription => 'Col·lecció de programari',
        Items => {0 => 'Aplicació',
                  1 => 'Aplicació',
                  X => 'Aplicacions',
                  lowercase1 => 'aplicació',
                  lowercaseX => 'aplicacions'},
        NewItem => 'Aplicació Nova',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Nom',
        Platform => 'Plataforma',
        Released => 'Data de sortida',
        Homepage => 'Pàgina web',		
        Editor => 'Editor',
        Developer => 'Desenvolupador',
        Category => 'Categoria',
		NumberOfCopies => 'Còpies',
		Price => 'Preu',
        Box => 'Imatge de la caixa',
        Case => 'Cas',
        Manual => 'Manual d\'instruccions',
        Executable => 'Executable',
        Description => 'Descripció',
        License => 'Llicència',
        Commercial => 'Comercial',
		FreewareNoncommercial => 'Freeware (per a us no comercial)',		
		OtherOpenSource => 'Altre codi obert',
		PublicDomain => 'Domini públic',
		OtherLicense => 'Altre',
		Registration => 'Registre',				
		RegistrationInfo => 'Informació de registre',		
		RegInfo => 'Informació de registre',
		RegistrationName => 'Nom d\'usuari',
		RegistrationNumber => 'Número de registre',		
		PanelRegistration => 'Informació de registre',	
		RegistrationComments => 'Informació o cometaris adicionals',
        Screenshots => 'Captures de pantalla',
        Screenshot1 => 'Captura de la primera pantalla',
        Screenshot2 => 'Captura de la segona pantalla',
        Comments => 'Comentaris',
        Url => 'Pàgina web',
        General => 'General',
        Details => 'Detalls',
        Information => 'Informació',

        FilterRatingSelect => 'Qualificació com a _Mínim...',
     );
}

1;
