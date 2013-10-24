package GCUpdater;

###################################################
#
#  Copyright 2005 Tian
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

use utf8;
use strict;

use LWP;

my $BASE_URL = 'http://www.gcstar.org/update/';
my $INDEX_FILE = 'list.php';

{
    package GCRealUpdater;

    use File::Basename;
    use File::Path;
    
    sub abort
    {
        my ($self, $msg) = @_;
        print "$msg\n";
        exit 1;
    }
    
    sub getNextFile
    {
        my $self = shift;
        
        return $self->{filesList}->[$self->{next}];
    }
    
    sub createBrowser
    {
        my ($self, $proxy) = @_;

        $self->{browser} = LWP::UserAgent->new;            
        $self->{browser}->proxy(['http'], $proxy) if $proxy;
    }
    
    sub checkFile
    {
        my ($self, $file) = @_;
        
        return 1 if $self->{toBeUpdated}->{all};
        foreach ('plugins', 'import', 'export', 'lang', 'models', 'extract')
        {
            return 1 if ($self->{toBeUpdated}->{$_}) && ($file =~ /$_/i);
        }
        return 0;
    }
    
    sub updateNext
    {
        my $self = shift;
        
        my $file = $self->{filesList}->[$self->{next}];
        print "Saving in ",$self->{baseInstallation}.$file,"\n";
        mkpath(dirname($self->{baseInstallation}.$file));
        my $response = $self->{browser}->get($self->{baseUrl}.$file, ':content_file' => $self->{baseInstallation}.$file);
        if (!$response->is_success)
        {
            print $response->message, "\n";
            #print $self->{lang}->{UpdateFileNotFound},"\n";
        }
        $self->{next}++;
    }
    
    sub getIndex
    {
        my $self = shift;
        my $response = $self->{browser}->get($self->{baseUrl}.$INDEX_FILE, ':content_file' => $self->{baseInstallation}.$INDEX_FILE);
        $self->abort($self->{lang}->{UpdateNone}) if !$response->is_success;
        open INDEX, $self->{baseInstallation}.$INDEX_FILE;
        $self->{filesList} = [];
        while (<INDEX>)
        {
            chomp;
            push @{$self->{filesList}}, $_
                if $self->checkFile($_);
        }
        close INDEX;
        $self->{total} = scalar @{$self->{filesList}};
    }
    
    sub total
    {
        my $self = shift;
        $self->getIndex if ( !defined $self->{total});
        return $self->{total};
    }
    
    sub new
    {
        my ($proto, $lang, $baseDir, $toBeUpdated, $version) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {
            lang => $lang,
            baseUrl => $BASE_URL.$version.'/',
            baseInstallation => $baseDir.'/',
            toBeUpdated => $toBeUpdated
        };
        bless ($self, $class);
        $self->abort($self->{lang}->{UpdateNoPermission}.$baseDir) if (! -w $baseDir);     
        $self->{next} = 0;
        $self->{total} = undef;

        return $self;        
    }
}

{
    package GCTextUpdater;
    
    sub new
    {
        my ($proto, $lang, $baseDir, $toBeUpdated, $noProxy, $version) = @_;
        my $class = ref($proto) || $proto;
        my $self  = {
            lang => $lang,
            noProxy => $noProxy,
            updater => GCRealUpdater->new($lang, $baseDir, $toBeUpdated, $version)
        };
        bless ($self, $class);
        return $self;
    }
    
    sub update
    {
        my $self = shift;
        
        my $proxy;
        if (!$self->{noProxy})
        {
            print $self->{lang}->{UpdateUseProxy};
            $proxy = <STDIN>;
            chomp $proxy;
        }
        
        $self->{updater}->createBrowser($proxy);
        
        my $count = $self->{updater}->total;
        print $self->{lang}->{UpdateNone},"\n" if !$count;
        for (my $i = 0; $i < $count; $i++)
        {
            print $i+1," / $count : ",$self->{updater}->getNextFile,"\n";
            $self->{updater}->updateNext;
        }
    }
}



1;
