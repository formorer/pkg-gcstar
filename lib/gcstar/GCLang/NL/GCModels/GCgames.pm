{
    package GCLang::NL::GCModels::GCgames;

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
    
        CollectionDescription => 'Collectie computerspellen',
        Items => {0 => 'Spel',
                  1 => 'Spel',
                  X => 'Spellen'},
        NewItem => 'Nieuw spel',
    
        Id => 'Id',
        Ean => 'EAN',
        Name => 'Naam',
        Platform => 'Platform',
        Players => 'Aantal spelers',
        Released => 'Uitgegeven',
        Editor => 'Montage',
        Developer => 'Ontwikkelaar',
        Genre => 'Genre',
        Box => 'Afbeelding van de doos',
        Case => 'Zaak',
        Manual => 'Handleiding',
        Completion => 'Voltooid (%)',
        Executable => 'Uitvoerbaar bestand',
        Description => 'Beschrijving',
        Codes => 'Codes',
        Code => 'Code',
        Effect => 'Effect',
        Secrets => 'Geheimen',
        Screenshots => 'Schermafdrukken',
        Screenshot1 => 'Eerste schermafdruk',
        Screenshot2 => 'Tweede schermafdruk',
        Comments => 'Opmerkingen',
        Url => 'Webpagina',
        Unlockables => 'ontgrendelbare',
        Unlockable => 'ontgrendelbaar',
        Howto => 'Hoe te ontgrendelen',
        Exclusive => 'Exclusive',
        Resolutions => 'Display resolutions',
        InstallationSize => 'Size',
        Region => 'Region',
        SerialNumber => 'Serial Number',        

        General => 'Algemeen',
        Details => 'Details',
        Tips => 'Tips',
        Information => 'Informatie',

        FilterRatingSelect => 'Minimum waardering...',
     );
}

1;
