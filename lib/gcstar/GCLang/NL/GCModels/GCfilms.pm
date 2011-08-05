{
    package GCLang::NL::GCModels::GCfilms;

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
    
        CollectionDescription => 'Collectie films',
        Items => {0 => 'Film',
                  1 => 'Film',
                  X => 'Films'},
        NewItem => 'Nieuwe film',
    
    
        Id => 'Id',
        Title => 'Titel',
        Date => 'Datum',
        Time => 'Speelduur',
        Director => 'Director',
        Country => 'Land',
        MinimumAge => 'Minimum leeftijd',
        Genre => 'Genre',
        Image => 'Afbeelding',
        Original => 'Originele titel',
        Actors => 'Acteurs',
        Actor => 'Acteur',
        Role => 'Rol',
        Comment => 'Opmerkingen',
        Synopsis => 'Synopsis',
        Seen => 'Gezien',
        Number => '# van de Media',
        Format => 'Media',
        Region => 'Regio',
        Identifier => 'Identificatie',
        Url => 'Webpagina',
        Audio => 'Geluid',
        Video => 'Videoformaat',
        Trailer => 'Videobestand',
        Serie => 'Serie',
        Rank => 'Rank',
        Subtitles => 'Ondertitels',

        SeenYes => 'Gezien',
        SeenNo => 'Niet Gezien',

        AgeUnrated => 'Niet geschat',
        AgeAll => 'Alle leeftijden',
        AgeParent => 'Begeleiding ouders',

        Main => 'Hoofditems',
        General => 'Algemeen',
        Details => 'Details',

        Information => 'Informatie',
        Languages => 'Talen',
        Encoding => 'Codering',

        FilterAudienceAge => 'Leeftijdcategorie',
        FilterSeenNo => '_Nog niet gezien',
        FilterSeenYes => '_Al gezien',
        FilterRatingSelect => 'Minimum waardering...',

        ExtractSize => 'Grootte',
     );
}

1;
