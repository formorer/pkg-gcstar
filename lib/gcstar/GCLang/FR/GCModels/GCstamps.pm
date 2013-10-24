{
    package GCLang::FR::GCModels::GCstamps;

    use utf8;
###################################################
#
#  Copyright 2005-2007 Tian
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

        CollectionDescription => 'Collection de timbres',
        Items => {0 => 'Timbres',
                  1 => 'Timbre',
                  X => 'Timbres',
                  I1 => 'Un timbre',
                  D1 => 'Le timbre',
                  DX => 'Les timbres',
                  DD1 => 'Du timbre',
                  M1 => 'Ce timbre',
                  C1 => ' timbre',
                  DA1 => 'e timbre',
                  DAX => 'e timbres'},
        NewItem => 'Nouveau timbre',

        General => 'Général',
        Detail => 'Détail',
        Value => 'Valeur',
        Notes => 'Notes',
        Views => 'Vues',

        Name => 'Nom',
        Country => 'Pays',
        Year => 'Année',
        DateIssue => 'Date d\'émission',
        Catalog => 'Catalogue',
        Number => 'Numéro',
        Topic => 'Thématique',
        Serie => 'Série',
        Designer => 'Dessinateur',
        Engraver => 'Graveur',
        Type => 'Genre',
        Format => 'Format',
        Description => 'Description',
        Color => 'Couleur',
        Gum => 'Gomme',
        Paper => 'Papier',
        Perforation => 'Dentelure',
        PerforationSize => 'Taille de la dentelure',
        CancellationType => 'Type d\'oblitération',
        Comments => 'Commentaires',
        PrintingVariety => 'Type d\'impression',
        IssueDate => 'Date d\'émission',
        EndOfIssue => 'Fin d\'émission',
        Issue => 'Quantité émise',
        Grade => 'Qualité',
        Status => 'Statut',
        Adjusted => 'Centrage',
        Cancellation => 'Oblitération',
        CancellationCondition => 'Condition d\'oblitération',
        GumCondition => 'Etat de la gomme',
        PerforationCondition => 'Etat de la dentelure',
        ConditionNotes => 'Notes sur la condition',
        Error => 'Erreur',
        ErrorNotes => 'Notes d\'erreur',
        FaceValue => 'Valeur faciale',
        MintValue => 'Valeur neuve',
        UsedValue => 'Valeur oblitérée',
        PurchasedDate => 'Date d\'achat',
        Quantity => 'Quantité',
        History => 'Historique',
        Picture1 => 'Image 1',
        Picture2 => 'Image 2',
        Picture3 => 'Image 3',

        AirMail => 'Poste aérienne',
        MilitaryStamp => 'Timbre de franchise militaire',
        Official => 'Timbre de service',
        PostageDue => 'Timbre taxe',
        Regular => 'Timbre ordinaire',
        Revenue => 'Timbre fiscal',
        SpecialDelivery => 'Exprès',
        StrikeStamp => 'Timbre de grève',
        TelegraphStamp => 'Timbre télégraphe',
        WarStamp => 'Timbre de guerre',
        WarTaxStamp => 'Timbre d\'impôt de guerre',

        Booklet => 'Carnet',
        BookletPane => 'Bande de carnet',
        Card => 'Carte',
        Coil => 'Timbre de roulette',
        Envelope => 'Enveloppe',
        FirstDayCover => 'Lettre premier jour',
        Sheet => 'Bloc feuillet',
        Single => 'Timbre seul',

        OriginalGum => 'Gomme d\'origine',
        Ungummed => 'Non gommé',
        Regummed => 'Regommé',

        Chalky => 'Papier couché',
        ChinaPaper => 'Papier de Chine',
        Coarsed => 'Papier rugueux',
        Glossy => 'Papier glacé',
        Granite => 'Papier granite',
        Laid => 'Papier vergé',
        Manila => 'Papier bulle',
        Native => 'Papier d\'origine',
        Pelure => 'Papier pelure',
        Quadrille => 'Papier quadrillé',
        Ribbed => 'Papier côtelé',
        Rice => 'Papier de riz',
        Silk => 'Papier de soie',
        Smoothed => 'Papier souple',
        Thick => 'Papier épais',
        Thin => 'Papier mince',
        Wove => 'Papier vélin',
        
        Heliogravure => 'Héliogravure',
        Lithography => 'Lithographie',
        Offset => 'Offset',
        Photogravure => 'Photogravure',
        RecessPrinting => 'Taille douce',
        Typography => 'Typographie',
        
        CoarsedPerforation => 'Dentelure grossière',
        CombPerforation => 'Dentelure en peigne',
        CompoundPerforation => 'Dentelure mixte',
        DamagedPerforation => 'Dentelure endommagée',
        DoublePerforation => 'Dentelure double',
        HarrowPerforation => 'Dentelure à la herse',
        LinePerforation => 'Dentelure linéaire',
        NoPerforation => 'Aucune dentelure',

        CancellationToOrder => 'Oblitération de complaisance',
        FancyCancellation => 'Oblitération fantaisie',
        FirstDayCancellation => 'Oblitération premier jour',
        NumeralCancellation => 'Oblitération numérique',
        PenMarked => 'Oblitération à la plume',
        RailroadCancellation => 'Oblitération ferroviaire',
        SpecialCancellation => 'Oblitération spéciale',

        Superb => 'Superbe',
        ExtraFine => 'Premier choix',
        VeryFine => 'Très beau',
        FineVeryFine => 'Beau/Très beau',
        Fine => 'Beau',
        Average => 'Moyen',
        Poor => 'Mauvais',

        Owned => 'Possédé',
        Ordered => 'Commandé',
        Sold => 'Vendu',
        ToSell => 'A vendre',
        Wanted => 'Souhaité',

        LightCancellation => 'Légère oblitération',
        HeavyCancellation => 'Forte oblitération',
        ModerateCancellation => 'Oblitération modérée',

        MintNeverHinged => 'Intacte',
        MintLightHinged => 'Légère trace de charnière',
        HingedRemnant => 'Marque de charnière',
        HeavilyHinged => 'Grande trace de charnière',
        LargePartOriginalGum => 'Gomme originale sur grande surface',
        SmallPartOriginalGum => 'Gomme originale sur petite surface',
        NoGum => 'Dégommé',

        Perfect => 'Parfaite',
        VeryNice => 'Très belle',
        Nice => 'Belle',
        Incomplete => 'Incomplète',
     );
}

1;
