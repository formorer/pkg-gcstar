{
    package GCLang::NL::GCImport::GCImportFolder;

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
    use GCLang::GCLangUtils;

    our @EXPORT = qw(%lang);

    our %lang = (
        'Name' => 'Map',
        'Recursive' => 'Doorblader sub-mappen',
        'Suffixes' => 'Achtervoegsels of extensies van de bestanden',
        'SuffixesTooltip' => 'Een door komma\'s gescheiden lijst van achtervoegsels of extensies van de te overwegen bestanden',
        'Remove' => 'Om te worden verwijderd uit de namen',
        'RemoveTooltip' => 'Een door komma\'s gescheiden lijst van woorden dat uit de bestandsnamen verwijderd moeten worden om de opgehaalde namen aan te maken',
        'Ask'=> 'Ask',
        'AskEnd'=> 'Ask all at end',
        'AddWithoutInfo'=> 'Add without infos',
        'DontAdd'=> 'Do not add',
        'TakeFirst' => 'Select first',
        'MultipleResult'=> 'Multiple results',
        'MultipleResultTooltip'=> 'What do we do when more than 1 result is return by the plugin',
        'RemoveWholeWord' => 'Remove only whole words',
        'NoResult'=> 'No results',
        'NoResultTooltip'=> 'What do we do when no search results is return by the plugin',
        'RemoveTooltipWholeWord' => 'Words will be removed only if they appear as an entire word',
        'RemoveRegularExpr' => 'Regular expression',
        'RemoveTooltipRegularExpr' => 'Consider that \'To be removed from names\' is a perl regular expression',
        'SkipFileAlreadyInCollection' => 'Add new files only',
        'SkipFileAlreadyInCollectionTooltip' => 'Add only files not already in the collection',
        'SkipFileNo' => 'No',
        'SkipFileFullPath' => 'based on full path',
        'SkipFileFileName' => 'based on file name',
        'SkipFileFileNameAndUpdate' => 'based on file name (but update path in collection)',
        'InfoFromFileNameRegExp' => 'Parse file name with this regular expression',
        'InfoFromFileNameRegExpTooltip' => 'Use this to retrieve infos from filename (applied after removing extension).\nLeave empty if not needed.\nKnown fields : \n$T:Title, $A:Alphabetised title, $Y:Release date, $S:Season, $E:Episode, $N:Alphabetised serie name, $x:Part number, $y: Total part number',

     );

    # Deze plug-in deelt enkele waarden met ImportList, het voegt hen van het toe
    importTranslation('List');
}

1;
