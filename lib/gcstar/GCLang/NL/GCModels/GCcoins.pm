{
    package GCLang::NL::GCModels::GCcoins;

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
    
        CollectionDescription => 'Numismatische collectie',
        Items => {0 => 'Muntstuk',
                  1 => 'Muntstuk',
                  X => 'Muntstukken'},
        NewItem => 'Nieuw muntstuk',

        Name => 'Naam',
        Country => 'Land',
        Year => 'Jaar',
        Currency => 'Valuta',
        Value => 'Waarde',
        Picture => 'Hoofdafbeelding',
        Diameter => 'Diameter',
        Metal => 'Metaal',
        Edge => 'Rand',
        Edge1 => 'Rand 1',
        Edge2 => 'Rand 2',
        Edge3 => 'Rand 3',
        Edge4 => 'Rand 4',
        Head => 'Kop',
        Tail => 'Munt',
        Comments => 'Opmerkingen',
        History => 'Geschiedenis',
        Website => 'Webpagina',
        Estimate => 'Raming',
        References => 'Referenties',
        Type => 'Type',
        Coin => 'Muntstuk',
        Banknote => 'Bankbiljet',

        Main => 'Hoofd',
        Description => 'Beschrijving',
        Other => 'Overige informatie',
        Pictures => 'Afbeeldingen',
        
        Condition => 'Toestand (PCGS)',
        Grade1  => 'BS-1',
        Grade2  => 'FR-2',
        Grade3  => 'AG-3',
        Grade4  => 'G-4',
        Grade6  => 'G-6',
        Grade8  => 'VG-8',
        Grade10 => 'VG-10',
        Grade12 => 'F-12',
        Grade15 => 'F-15',
        Grade20 => 'VF-20',
        Grade25 => 'VF-25',
        Grade30 => 'VF-30',
        Grade35 => 'VF-35',
        Grade40 => 'XF-40',
        Grade45 => 'XF-45',
        Grade50 => 'AU-50',
        Grade53 => 'AU-53',
        Grade55 => 'AU-55',
        Grade58 => 'AU-58',
        Grade60 => 'MS-60',
        Grade61 => 'MS-61',
        Grade62 => 'MS-62',
        Grade63 => 'MS-63',
        Grade64 => 'MS-64',
        Grade65 => 'MS-65',
        Grade66 => 'MS-66',
        Grade67 => 'MS-67',
        Grade68 => 'MS-68',
        Grade69 => 'MS-69',
        Grade70 => 'MS-70',
    
     );
}

1;
