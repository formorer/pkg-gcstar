{
    package GCLang::NL::GCExport::GCExportHTML;

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
        'ModelNotFound' => 'Ongeldig sjabloonbestand',
        'UseFile' => 'Gebruik het hieronder gespecificeerde bestand',
        'WithJS' => 'Gebruik Javascript',
       	'FileTemplate' => 'Sjabloon',
        'Preview' => 'Voorbeeld',
        'NoPreview' => 'Geen voorbeeld beschikbaar',
        'TemplateExternalFile' => 'Sjabloonbestand',
        'Title' => 'Paginatitel',
        'InfoFile' => 'Filmlijst staat in het bestand: ',
        'InfoDir' => 'Afbeeldingen staan in: ',
        'HeightImg' => 'Hoogte (in pixels) van het uit te voeren beeld',
        'OpenFileInBrowser' => 'Open gegenereerd bestand in de webbrowser',
        'Note' => 'Lijst gegenereerd door <a href="http://www.gcstar.org/">GCstar</a>',
        'InputTitle' => 'Geef de gezochte tekst',
        'SearchType1' => 'Titel alleen',
        'SearchType2' => 'Volledige informatie',
        'SearchButton' => 'Zoek',    
        'SearchTitle' => 'Toon enkel films overeenstemmend met voorgaande criteria',
        'AllButton' => 'Alle',
        'AllTitle' => 'Toon alle films',
        'Expand' => 'Alles uitvouwen',
        'ExpandTitle' => 'Toon alle informatie van de films',
        'Collapse' => 'Alles dichtvouwen',
        'CollapseTitle' => 'Verberg alle informatie van de films',
        'Borrowed' => 'Geleend door: ',
        'NotBorrowed' => 'Beschikbaar',
        'Top' => 'Bovenaan',
        'Bottom' => 'Onderaan',
     );
}

1;
