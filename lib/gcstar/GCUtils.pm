package GCUtils;

###################################################
#
#  Copyright 2005-2010 Christian Jodar
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
use Exporter;
use Cwd 'abs_path';
use Gtk2;

use base 'Exporter';
our @EXPORT_OK = qw(glob);

our $margin = 12;
our $halfMargin = $margin / 2;
our $quarterMargin = $margin / 4;

sub updateUI
{
    my $loopCount = 0;
    my $nbEvent = Gtk2->events_pending;
    while ($nbEvent && ($loopCount < 30))
    {
        Gtk2->main_iteration;
        $loopCount++;
        $nbEvent = Gtk2->events_pending;
    }
}

sub printStack
{
    my $number = shift;
    $number ||= 1;
    my ($package, $filename, $line, $subroutine) = caller(1);
    my $output = "$package::$subroutine";
    my $frame = 2;
    while (($number + 1) >= $frame)
    {
        ($package, $filename, $line, $subroutine) = caller($frame);
        $output .= " from $package::$subroutine";
        $frame++;
    }
    print "$output\n";
}

sub dumpList
{
    my ($list, @fields) = @_;
    my $i = 0;
    foreach my $item(@$list)
    {
        print $i, ': ';
        print $item->{$_}, ", " foreach (@fields);
        print "\n";
        $i++;
    }
}

sub formatOpenSaveError
{
    my ($lang, $filename, $error) = @_;
    
    my $errorText = (exists $lang->{$error->[0]})
                     ? $lang->{$error->[0]}
                     : $error->[0];
    return "$filename\n\n$errorText".($error->[1] ? "\n\n".$error->[1] : '');
}

sub glob
{
    my ($pattern) = @_;
    $pattern = '"'.$pattern.'"' if $pattern =~ /[^\\] /;
    return glob "$pattern";
}

sub pathToUnix
{
    my ($path, $canonical) = @_;
    $path =~ s|\\|/|g if ($^O =~ /win32/i);
    $path = abs_path($path) if $canonical;
    return $path;
}

sub sizeToHuman
{
    my ($size, $sizesSymbols) = @_;
    
    #my @prefixes = ('', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y');
    my $i = 0;
    while ((($size / 1024) > 1) && ($i < scalar @$sizesSymbols))
    {
        $size /= 1024;
        $i++;
    }
    return sprintf("%.1f %s%s", $size, $sizesSymbols->[$i]);
}

sub getSafeFileName
{
    my $file = shift;
    
    $file =~ s/[^-a-zA-Z0-9_.]/_/g;
    return $file;
}

sub boolToText
{
    my $value = shift;
    
    return $value ? 'true' : 'false';
}

sub listNameToNumber
{
    my $value = shift;
    
    return 1 if $value =~ /single/;
    return 2 if $value =~ /double/;
    return 3 if $value =~ /triple/;
    return 4 if $value =~ /quadruple/;
    return 0;
}

sub encodeEntities
{
    my $value = shift;
    $value =~ s/&/&amp;/g;
    $value =~ s/</&lt;/g;
    $value =~ s/>/&gt;/g;
    $value =~ s/"/&quot;/g;
    #"
    return $value;
}

sub compactHistories
{
    my $histories;
    foreach (keys %$histories)
    {
        my %allKeys;
        @allKeys{@{$histories->{$_}}} = ();
        my @unique = keys %allKeys;
        $histories->{$_} = \@unique;
    }
}

use HTML::Entities; 
# Strips readable text from RTF formatted strings
sub RtfToString
{
    my ($rtfString) = @_;
    
    my $str = $rtfString;
    
    # First, decode any symbols present
    $str = decode_entities($str);
    # Strip leading {
    $str =~ s/^\{//;
    # Strip out all the formatting within {}'s
    $str =~ s/\{(.)*;\}//gs;
    # Strip trailing }
    $str =~ s/\}$//;
    # Get the text from "\'d5" type tags
    $str =~ s/\\(.)d\d/$1/g;
    # Strip out all the remaining formatting
    $str =~ s/\\(\H)*[\s]//g;
    # And any newlines, since they'll be randomly placed now
    $str =~ s/\n//g;    
                
    return $str;
}


{
    package GCPreProcess;

    use Text::Wrap;

    sub singleList
    {
        my $value = shift;
        if (ref($value) eq 'ARRAY')
        {
            my $string = '';
            foreach (@{$value})
            {
                $string .= $_->[0].', ';
            }
            $string =~ s/ \(\)//g;
            $string =~ s/, $//;
            return $string;
        }
        else
        {
            $value =~ s/,*$//;
            $value =~ s/,([^ ])/, $1/g;
            return $value;
        }
    }
    
    sub doubleList
    {
        my $value = shift;
        if (ref($value) eq 'ARRAY')
        {
            my $string = '';
            foreach (@{$value})
            {
                my $val0 = (exists $_->[0]) ? $_->[0] : '';
                my $val1 = '';
                $val1 = '('.$_->[1].')' if defined ($_->[1]);
                $string .= "$val0 $val1, ";
            }
            $string =~ s/ \(\)//g;
            $string =~ s/, $//;
            return $string;
        }
        else
        {
            $value =~ s/;/,/g if $value !~ /,/;
            $value =~ s/;(.*?)(,|$)/ ($1)$2/g;
            $value =~ s/,([^ ])/, $1/g;
            $value =~ s/ \(\)//g;
            $value =~ s/(, ?)*$//;
            return $value;
        }
    }

    sub otherList
    {
        my $value = shift;
        if (ref($value) eq 'ARRAY')
        {
            my $string = '';
            foreach my $line(@{$value})
            {
                $string .= $_.'|' foreach (@{$line});
                $string .= ', ';
            }
            $string =~ s/, $//;
            return $string;
        }
        else
        {
            $value =~ s/,([^ ])/, $1/g;
            $value =~ s/(, ?)*$//;
            return $value;
        }
    }

    sub multipleList
    {
        my ($value, $number) = @_;

        $number = GCUtils::listNameToNumber($number) if $number !~ /^[0-9]+$/;

        return singleList($value) if $number == 1;
        return doubleList($value) if $number == 2;
        #We only return the first column of each line in a string
        return otherList($value);
    }
    
    sub multipleListToArray
    {
        my $value = shift;
        my @result;
        if (ref($value) eq 'ARRAY')
        {
            foreach (@{$value})
            {
                push @result, $_->[0];
            }
        }
        else
        {
            @result = split /,\s*/, $value;
        }
        return \@result;
    }
    
    sub wrapText
    {
        my ($widget, $text) = @_;
        my $width = $widget->allocation->width;
        $width -= 30;
        (my $oneline = $text) =~ s/\n/ /gm;
        my $layout = $widget->create_pango_layout($oneline);
        my (undef, $rect) = $layout->get_pixel_extents;
        my $textWidth = $rect->{width};
        my $lines = $textWidth / $width;
        $lines = 1 if $lines <= 0;
        my $columns = length($text) / $lines;
        use integer;
        $Text::Wrap::columns = $columns - 5;
        $Text::Wrap::columns = 1 if $Text::Wrap::columns <= 0;
        no integer;
        $text = Text::Wrap::wrap('', '', $text);
        return $text;        
    }
    
    # Useful to compare date
    sub reverseDate
    {
        (my $date = shift) =~ s|([0-9]{2})/([0-9]{2})/([0-9]{4})|$3/$2/$1|;
        return $date;
    }
    
    sub restoreDate
    {
        (my $date = shift) =~ s|([0-9]{4})/([0-9]{2})/([0-9]{2})|$3/$2/$1|;
        return $date;
    }

    sub extractYear
    {
        my $date = shift;
        
        return 0 if $date !~ /[0-9]{4}/;
        (my $year = $date) =~ s/.*?(([0-9]{4})).*?/$1/;
        
        return $year;
    }
    
    sub noNullNumber
    {
        my $num = shift;
        return 0 if ($num eq '') || (! defined($num));
        return $num;
    }
}

sub round 
{
    my $number = shift;
    return int($number + .5);
}

sub urlDecode
{
    my $text = shift;
    $text =~ tr/+/ /;
    $text =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
    return $text;
}

sub scaleMaxPixbuf
{
    my ($pixbuf, $maxWidth, $maxHeight, $forceScale, $quick) = @_;

    my $algorithm = $quick ? 'nearest' : 'bilinear';

    if ($forceScale)
    {
        $pixbuf = $pixbuf->scale_simple($maxWidth, $maxHeight, $algorithm);
    }
    else
    {
        my ($width, $height) = ($pixbuf->get_width, $pixbuf->get_height);
        if (($height > $maxHeight) || ($width > $maxWidth))
        {
            my ($newWidth, $newHeight);
            my $ratio = $height / $width;
            if (($width) * ($maxHeight / $height) < $maxWidth)
            {
                $newHeight = $maxHeight;
                $newWidth = $newHeight / $ratio;
            }
            else
            {
                $newWidth = $maxWidth;
                $newHeight = $newWidth * $ratio;
            }

            $pixbuf = $pixbuf->scale_simple($newWidth, $newHeight, $algorithm);
        }
    }

    return $pixbuf;
}

sub findPosition
{
    use locale;
    my ($label, $menu) = @_;
    
    my @children = $menu->get_children;
    my $i = 0;
    my $child;
    foreach $child(@children)
    {
        return $i if (($i !=0) && ($child->child->get_label() gt $label));
        $i++;
    }
    return $i;
}

sub inArray
{
    my $val = shift;
 
    my $i = 0;
    my $elem;
    foreach $elem(@_)
    {
        if($val eq $elem)
        {
            return $i;
        }
        $i++;
    }
    return undef;
}

sub inArrayTest
{
    my $val = shift;
    my $elem;
    foreach $elem(@_)
    {
        return 1 if($val eq $elem);
    }
    return 0;
}

my $rc_style = Gtk2::RcStyle->new;

sub setWidgetPixmap
{
    my ($widget, $imageFile) = @_;
    $rc_style->bg_pixmap_name('normal', $imageFile);
    $rc_style->bg_pixmap_name('insensitive', $imageFile);
    $widget->modify_style($rc_style);

#    my $style = $widget->parent->get_style->copy;
#    $style->bg_pixmap('normal', $image);
#    $style->bg_pixmap('insensitive', $image);
#    $style->bg_pixmap('active', $image);
#    $style->bg_pixmap('prelight', $image);
#    $style->bg_pixmap('selected', $image);
#    $widget->parent->set_style($style);

}

use File::Basename;

sub getDisplayedImage
{
    my ($displayedImage, $default, $file, $fileDir) = @_;

    if (!File::Spec->file_name_is_absolute($displayedImage))
    {
        my $dir;
        if ($file)
        {
            $dir = ($fileDir || dirname($file));
        }
        else
        {
            $dir = '.';
        }
        if (-f "$dir/$displayedImage")
        {
            $displayedImage = $dir.'/'.$displayedImage;
        }
        else
        {
            $displayedImage = $default unless (-e $displayedImage);
        }
    }
    $displayedImage = $default if ! -f $displayedImage;

    return GCUtils::pathToUnix($displayedImage);
}

use LWP::UserAgent;
sub downloadFile
{
    my ($url, $dest, $settings) = @_;
    my $browser = LWP::UserAgent->new;
    $browser->proxy(['http'], $settings->{options}->proxy);
    $browser->cookie_jar(HTTP::Cookies::Netscape->new(
        'file' => $settings->{options}->cookieJar));
    $browser->agent($settings->{agent});
    $browser->default_headers->referer($url);
    $browser->get($url, ':content_file' => $dest);
}

use POSIX qw/strftime/;
sub timeToStr
{
    my ($date, $format) = @_;
    my @array=split("/", $date);
    return $date if $#array != 2;
    return strftime($format, 0, 0, 0, $array[0], $array[1]-1, $array[2]-1900);
}

sub TimePieceStrToTime
{
    my ($date, $format) = @_;
    my $str;
    eval {
        my $t = Time::Piece->strptime($date, $format);
        $str = sprintf('%02d/%02d/%4d', $t->mday, $t->mon, $t->year);
    };
    if ($@)
    {
        return $date;
    }
    return $str;
}

sub DateTimeFormatStrToTime
{
    my ($date, $format) = @_;
    my $str;
    eval {
        my $dt = new DateTime::Format::Strptime(
                                pattern     => $format,
                                locale      => $ENV{LANG});
        my $dt2 = $dt->parse_datetime($date);
        $dt->pattern('%d/%m/%Y');
        $str = $dt->format_datetime($dt2);
    };
    if ($@)
    {
        return $date;
    }
    return $str;
}

# Our custom natural sort function
sub gccmp
{
    use locale;
    my ($string1, $string2) = @_;
    
    my $test1 = $string1;
    my $test2 = $string2;
    
    # Split strings into arrays by seperating strings from numbers
    my $nb1 = ($test1 =~ s/(\d+)/\|$+\|/g);
    my $nb2 = ($test2 =~ s/(\d+)/\|$+\|/g);
    
    # If there are no numbers in the test strings, just directly compare
    return $test1 cmp $test2
        if ($nb1 == 0) || ($nb2 == 0);
    
    my @test = split(/\|/,$test1);
    my @test2 = split(/\|/,$test2);

    # Compare each element in the strings
    my $result = 0;
    for (my $pass = 0; $pass < scalar @test; $pass++)
    {
        # Elements are the same, so keep searching
        next if ($test[$pass] eq $test2[$pass]);
        
        # If both elements are numbers, do a numerical compare
        if (($test[$pass] =~ /\d+/)  && ($test2[$pass] =~ /\d+/))      
        {
            # Number test
            $result = $test[$pass] <=> $test2[$pass];
        }
        else
        {
            # Test elements as strings
            $result = lc($test[$pass]) cmp lc($test2[$pass]);
        }
        last; 
    }
    
    return $result;
}

# Extended version of gccmp that also supports dates
# Only useful for image mode as text mode handles that in a better way
sub gccmpe
{
    my ($string1, $string2) = @_;
    
    my $test1 = $string1;
    my $test2 = $string2;

    if (($test1 =~ m|([0-9]{2})/([0-9]{2})/([0-9]{4})|)
     && ($test2 =~ m|([0-9]{2})/([0-9]{2})/([0-9]{4})|))
    {
        return (GCPreProcess::reverseDate($test1) cmp GCPreProcess::reverseDate($test2));
    }
    else
    {
        return gccmp($test1, $test2);
    }
}

our $hasTimeConversion;
BEGIN {
    $hasTimeConversion = 1;
    eval 'use DateTime::Format::Strptime qw/strptime/';
    if (!$@)
    {
        *strToTime = \&DateTimeFormatStrToTime;
    }
    else
    {
        eval 'use Time::Piece';
        if (!$@)
        {
            *strToTime = \&TimePieceStrToTime;
        }
        else        
        {
            $hasTimeConversion = 0;
            *strToTime = sub {return $_[0]};
            *timeToStr = sub {return $_[0]};
        }
    }
    
}


1;
