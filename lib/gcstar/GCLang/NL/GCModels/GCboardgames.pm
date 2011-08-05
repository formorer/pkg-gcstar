{
    package GCLang::NL::GCModels::GCboardgames;

    use utf8;
###################################################
#
#  Auteursrecht 2005-2009 Tian
#
#  Dit bestand is onderdeel van GCstar.
#
#  GCstar is gratis software; je kan het verspreiden en/ of wijzigen
#  onder de voorwaarden van de GNU General Public License zoals gepubliceerd door
#  de Free Software Foundation; ofwel versie 2 van de licentie, of
#  (op uw keuze) een latere versie.
#
#  GCstar wordt verspreid in de hoop dat het nuttig zal zijn
#  maar ZONDER ENIGE GARANTIE, zelfs zonder de impliciete garantie van
#  Verkoopbaarheid of geschiktheid voor een bepaald doel. Zie de
#  GNU General Public License voor meer details.
#
#  Je zou een kopie van de GNU General Public License moeten ontvangen hebben
#  samen met GCstar; zo niet, schrijf naar de Free Software
#  Foundation, Inc, 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
#
###################################################
    
    use strict;
    use base 'Exporter';

    our @EXPORT = qw(%lang);

    our %lang = (
    
        CollectionDescription => 'Collectie gezelschapsspellen',
        Items => {0 => 'Spel',
                  1 => 'Spel',
                  X => 'Spellen'},
        NewItem => 'Nieuw spel',
    
        Id => 'Id',
        Name => 'Naam',
        Original => 'Oorspronkelijke naam',
        Box => 'Afbeelding van de doos',
        DesignedBy => 'Ontworpen door',
        PublishedBy => 'Gepubliceerd door',
        Players => 'Aantal spelers',
        PlayingTime => 'Speelduur',
        SuggestedAge => 'Voorgestelde leeftijd',
        Released => 'Uitgegeven',
        Description => 'Beschrijving',
        Category => 'Categorie',
        Mechanics => 'Mechanisme(s)',
        ExpandedBy => 'Uitgebreid door',
        ExpansionFor => 'Uitbreiding voor',
        GameFamily => 'Spelgenre',
        IllustratedBy => 'Geïllustreerd door',
        Url => 'Webpagina',
        TimesPlayed => 'Aantal keer gespeeld',
        CompleteContents => 'Volledige inhoud',
        Copies => 'Aantal exemplaren',
        Condition => 'Staat',
        Photos => 'Foto\'s',
        Photo1 => 'Eerste foto',
        Photo2 => 'Tweede foto',
        Photo3 => 'Derde foto',
        Photo4 => 'Vierde foto',
        Comments => 'Opmerkingen',

        Perfect => 'Perfect',
        Good => 'Goed',
        Average => 'Gemiddeld',
        Poor => 'Slecht',

        CompleteYes => 'Volledige inhoud',
        CompleteNo => 'Ontbrekende stukjes',

        General => 'Algemeen',
        Details => 'Details',
        Personal => 'Persoonlijk',
        Information => 'Informatie',

        FilterRatingSelect => 'Minimum waardering...',
     );
}

1;
