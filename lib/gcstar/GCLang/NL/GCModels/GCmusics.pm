{
    package GCLang::NL::GCModels::GCmusics;

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
    
        CollectionDescription => 'Muziekcollectie',
        Items => {0 => 'Album',
                  1 => 'Album',
                  X => 'Albums'},
        NewItem => 'Nieuw album',
    
        Unique => 'ISRC/EAN',
        Title => 'Titel',
        Cover => 'Hoes',
        Artist => 'Artiest',
        Format => 'Formaat',
        Running => 'Speelduur',
        Release => 'Datum uitgave',
        Genre => 'Genre',
        Origin => 'Oorsprong',

#voor tracks lijst
        Tracks => 'Trackslijst',
        Number => 'Nummer',
        Track => 'Titel',
        Time => 'Duur',

        Composer => 'Componist',
        Producer => 'Producent',
        Playlist => 'Afspeellijst',
        Comments => 'Opmerkingen',
        Label => 'Label',
        Url => 'Webpagina',

        General => 'Algemeen',
        Details => 'Details',
     );
}

1;
