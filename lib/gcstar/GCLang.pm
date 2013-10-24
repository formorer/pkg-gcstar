{
    package GCLang;
    
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
use utf8;

use base 'Exporter';
our @EXPORT = qw(%langs);

use File::Basename;
use FindBin qw($RealBin $Script);
use GCUtils 'glob';
    
our %langs;
our $loaded = 0;

sub loadLang
{
    my ($lang, $nameOnly) = @_;
    
    if ($nameOnly)
    {
        # We directly read the file here to save time and memory
        open LANG, $ENV{GCS_LIB_DIR}."/GCLang/$lang/GCstar.pm" or return 0;
        binmode(LANG, ':utf8' );
        while (<LANG>)
        {
            next if !/LangName/;
            /'?LangName'?\s*=>\s*'(.*)'/;
            $langs{$lang} = {'LangName' => $1};
            last;
        }
        close LANG;
    }
    else
    {
        eval "use GCLang::${lang}::GCstar";
        my %tmpLang;
        eval "%tmpLang = %GCLang::${lang}::lang";
        return 0 if !%tmpLang;
        $langs{$lang} = \%tmpLang;
    }
    return 1;
}

sub loadLangs
{
    my $lang = shift;

    return if $loaded;
    if ($lang)
    {
        return 0 if !loadLang($lang);
        foreach (glob $ENV{GCS_LIB_DIR}.'/GCLang/*')
        {
            next if /CVS/ || /pm$/ || /$lang/;
            my $lang = basename($_);
            loadLang($lang, 1);
	    #$langs{$lang} = {'LangName' => $langs{$lang}{LangName}};
	    #eval "no GCLang::${lang}::GCstar";
        }
    }
    else
    {
        foreach (glob $ENV{GCS_LIB_DIR}.'/GCLang/*')
        {
            next if /CVS/ || /pm$/;
            my $lang = basename($_);
            loadLang($lang);
        }
    }
    $loaded = 1;
    return 1;
}

sub loadPluginsLangs
{
    foreach (glob $ENV{GCS_LIB_DIR}.'/GCLang/*')
    {
        next if /CVS/ || /pm$/;
        my $lang = basename($_);
        foreach my $dir(glob $ENV{GCS_LIB_DIR}."/GCLang/$lang/*")
        {
            next if /\.pm$/;
            foreach my $plugin(glob "$dir/*.pm")
            {
                my $module = basename($dir);
                my %tmpLang;
                ($plugin = basename($plugin)) =~ s/\.pm$//;
                eval "use GCLang::".$lang."::".$module."::".$plugin."\n";
                eval "%tmpLang = %GCLang::".$lang."::".$module."::".$plugin."::lang";
                foreach my $key(keys %tmpLang)
                {
                    $langs{$lang}->{$module.'/'.$plugin.".pm '".$key."'"} = $tmpLang{$key};
                }
            }
        }
    }
    
}

sub languageDirection
{
    my $lang = shift;

    $lang =~ m/([a-z]*)/;
    if ($1 eq 'ar')
    {
        # Langauge is RTL
        return 'RTL';
    }
    else
    {
        return 'LTR';
    }
}

# Used to convert a model-specific string to the full string (eg "New {1}" -> "New game")
sub updateModelSpecificStrings
{
    my ($self) = @_;

    # We need to make a copy of the original language strings, without the model-specific strings
    if (!$self->{originalLang})
    {
        %{$self->{originalLang}} = %{$self->{lang}};
    }
    
    my $itemStrings = $self->{model}->{lang}->{Items};
    # Add default lower case version if it doesn't exist, if the language has support for it
    if (ref $itemStrings eq 'HASH')
    {
        foreach (keys %{$itemStrings})
        {
            next if /lowercase/;
            next if exists $itemStrings->{'lowercase'.$_};
            $itemStrings->{'lowercase'.$_} = lc $itemStrings->{$_};
        }
    }
    # Now, go and replace any model-specific strings
    foreach my $string (keys %{$self->{lang}})
    {
        $self->{lang}->{$string} = $self->{originalLang}->{$string};
        if (ref $itemStrings eq 'HASH') 
        {
            $self->{lang}->{$string} =~ s/{(.*)}/$itemStrings->{$1}/e;
        }
        else
        {
            $self->{lang}->{$string} =~ s/{(.*)}/$itemStrings/e;
        }
    }
}

# Used to convert a single model-specific string to the full string (eg "New {1}" -> "New game")
sub getGenericModelString
{
    my ($self, $string) = @_;
    my $itemStrings = $self->{model}->{lang}->{Items};
    # Add default lower case version if it doesn't exist, if the language has support for it
    if (ref $itemStrings eq 'HASH')
    {
        foreach (keys %{$itemStrings})
        {
            next if /lowercase/;
            next if exists $itemStrings->{'lowercase'.$_};
            $itemStrings->{'lowercase'.$_} = lc $itemStrings->{$_};
        }
    }
    
    my $fixedString = $string;
    if (ref $itemStrings eq 'HASH') 
    {
        $fixedString =~ s/{(.*)}/$itemStrings->{$1}/e;
    }
    else
    {
        $fixedString =~ s/{(.*)}/$itemStrings/e;
    }
    return $fixedString;
}

# Used to check languages (which translation are missing)
# Usage: perl -e "use GCLang; GCLang::checkLangs"
sub checkLangs
{
    my @langsToCheck = @_;

    my $ref = 'EN';
    #my $otherRef = 'FR';
    
    loadLangs;
    loadPluginsLangs;
    
    my @langsList = scalar @langsToCheck ? @langsToCheck : keys %langs;
    
    my %results;
    foreach (sort keys %{$langs{$ref}})
    {
        foreach my $langName(@langsList)
        {
            next if $langName eq $ref;
            if (! exists $langs{$langName}->{$_})
            {
                push @{$results{$langName}{error}}, $_;
            }
            else
            {
                #next if $langName eq $otherRef;
                push @{$results{$langName}{warning}}, $_
                    if ($langs{$langName}->{$_} eq $langs{$ref}->{$_})
                #    || ($langs{$langName}->{$_} eq $langs{$otherRef}->{$_});
            }
        }
    }
    
    foreach (sort keys %results)
    {
        print "\n\nLang $_\n-------\n\n";
        print "Errors:\n\n";
        foreach my $value(@{$results{$_}{error}})
        {
            next if $value =~ m|^GC.*?/|;
            print "'$value' => '",$langs{$ref}->{$value},"',\n";
        }
        print "\n";
        foreach my $value(@{$results{$_}{error}})
        {
            next if $value !~ m|^GC.*?/|;
            print "$value => '",$langs{$ref}->{$value},"',\n";
        }
        next if $ENV{GCS_ERRORS_ONLY} eq 'YES';
        print "\nWarnings:\n\n";
        foreach my $value(@{$results{$_}{warning}})
        {
            next if $value =~ m|^GC.*?/|;
            print "'$value' => '",$langs{$_}->{$value},"',\n";
        }
        print "\n";
        foreach my $value(@{$results{$_}{warning}})
        {
            next if $value !~ m|^GC.*?/|;
            print "$value => '",$langs{$_}->{$value},"',\n";
        }
    }
}

    
}


1;
