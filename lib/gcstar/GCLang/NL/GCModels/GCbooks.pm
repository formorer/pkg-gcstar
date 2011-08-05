{
    package GCLang::NL::GCModels::GCbooks;

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
    
        CollectionDescription => 'Collectie boeken',
        Items => {0 => 'Boek',
                  1 => 'Boek',
                  X => 'Boeken'},
        NewItem => 'Nieuw boek',
    
        Isbn => 'ISBN',
        Title => 'Titel',
        Cover => 'Cover',
        Authors => 'Auteurs',
        Publisher => 'Uitgever',
        Publication => 'Publicatiedatum',
        Language => 'Taal',
        Genre => 'Genre',
        Serie => 'Serie',
        Rank => 'Rank',
        Bookdescription => 'Beschrijving',
        Pages => 'Pagina\'s',
        Read => 'Lees',
        Acquisition => 'Verkregen op',
        Edition => 'Uitgave',
        Format => 'Formaat',
        Comments => 'Opmerkingen',
        Url => 'Webpagina',
        Translator => 'Vertaler',
        Artist => 'Illustrator',
        DigitalFile => 'Digital version',

        General => 'Algemeen',
        Details => 'Details',

        ReadNo => 'Niet gelezen',
        ReadYes => 'Gelezen',
     );
}

1;
