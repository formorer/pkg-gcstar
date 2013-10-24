package GCExtract::GCExtractMusics;

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
use GCExtract;

use GCDialogs;
{
    package GCExtractMusicsResultsDialog;
    use base 'GCModalDialog';

    sub show
    {
        my $self = shift;
        
        $self->SUPER::show();
        $self->show_all;
        my $response = $self->run;
        my $idx = ($self->{results}->get_selected_indices)[0];
        $self->hide;
        return -1 if $response ne 'ok';
        return $idx;
    }

    sub setData
    {
        my ($self, @cddbData) = @_;
        my @listData;
        foreach(@cddbData)
        {
            push @listData, [$_->{genre}, $_->title, $_->artist, $_->year];
        }
        @{$self->{results}->{data}} = @listData;
        $self->{results}->select(0);
        $self->{results}->columns_autosize;
    }

    sub new
    {
        my ($proto, $parent, $model) = @_;
        my $class = ref($proto) || $proto;

        my $self  = $class->SUPER::new($parent,
                                       $model->getDisplayedText('ResultsDialog'));
        $self->{parent} = $parent;

        my $hbox = new Gtk2::HBox(0,0);
        
        $self->{results} = new Gtk2::SimpleList(
                $model->getDisplayedText('Genre') => 'text',
                $model->getDisplayedText('Title') => 'text',
                $model->getDisplayedText('Artist') => 'text',
                $model->getDisplayedText('Release') => 'text',
        );

        $self->{results}->set_rules_hint(1);
        $self->{results}->set_headers_clickable(1);
        for my $i (0..3)
        {
            my $column = $self->{results}->get_column($i);
            $column->set_resizable(1);
            $column->set_sort_column_id($i);
        }
        $self->{results}->signal_connect(row_activated => sub {
            $self->response('ok');
        });

        my $scrollPanelList = new Gtk2::ScrolledWindow;
        $scrollPanelList->set_policy ('never', 'automatic');
        $scrollPanelList->set_shadow_type('etched-in');
        $scrollPanelList->set_border_width($GCUtils::margin);
        $scrollPanelList->add($self->{results});

        $self->vbox->pack_start($scrollPanelList,1,1,0);

        $self->set_default_size(-1,300);
        return $self;
    }
}

{
    package GCExtract::GCmusicsExtracter;
    use base 'GCItemExtracter';
    
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new(@_);
        bless ($self, $class);

        $self->{hasMP3Info} = $self->checkModule('MP3::Info');
        $self->{hasMP3Tag} = $self->checkModule('MP3::Tag');
        $self->{hasOggVorbisHeader} = $self->checkModule('Ogg::Vorbis::Header::PurePerl');
        $self->{hasNetFreeDB} = $self->checkModule('Net::FreeDB');
        # Even if previous check fails, we want to use it for tracks feature
        $self->{errors} = 0;

        $self->{fields} = ['title', 'artist', 'release', 'genre', 'running', 'tracks'];
        return $self;
    }

    sub resetTracks
    {
        my $self = shift;
        $self->{tracks} = [];
        $self->{totalTime} = 0;
        $self->{currentTrack} = 0;
        $self->{firstTrack} = '';
    }

    sub addTrack
    {
        my ($self, $title, $time, $number) = @_;
        $self->{currentTrack}++;
        $self->{totalTime} += $time;
        $number = $self->{currentTrack} if !defined $number;
        push @{$self->{tracks}},
            [$number, $title, $self->secondsToString($time)];
    }

    sub getTracks
    {
        my $self = shift;
        return $self->{tracks};
    }

    sub secondsToString
    {
        my ($self, $time) = @_;
        return int($time / 60) .':'. sprintf '%02d', ($time %60);
    }

    sub getTotalTime
    {
        my $self = shift;
        return $self->secondsToString($self->{totalTime});
    }

    sub getM3UInfo
    {
        my ($self) = @_;
        my $file = $self->{file};
        my $info = {};
        while (<$file>)
        {
            chomp;
            s/\r//;
            if (/^#/)
            {
                next if ! /^#EXTINF:(.*)/;
                my @values = split /,/, $1;
                $self->addTrack($values[1], $values[0]);
            }
            else
            {
                $self->{firstTrack} = $_
                    if !$self->{firstTrack};
            }
        }
        $info->{tracks} = $self->getTracks;
        $info->{running} = $self->getTotalTime;
        return $info;
    }

    sub getPLSInfo
    {
        my ($self) = @_;
        my $file = $self->{file};
        my $info = {};
        my @tracks;
        while (<$file>)
        {
            chomp;
            s/\r//;
            next if ! /(File|Title|Length)(\d+)=(.*)$/;
            $tracks[$2]->{$1} = $3;
            $tracks[$2]->{Number} = $2;
        }
        foreach (@tracks)
        {
            next if !$_->{Title};
            $self->addTrack($_->{Title}, $_->{Length}, $_->{Number});
        }
            
        $info->{tracks} = $self->getTracks;
        $info->{running} = $self->getTotalTime;
        $self->{firstTrack} = $tracks[1]->{File};
        return $info;
    }

    sub getFreeDB
    {
        my @genres = qw(blues classical country data folk jazz newage reggae rock soundtrack misc);
        my ($self) = @_;
        my $file = $self->{fileName};
        my $info = {};
        return $info if ! -e $file;
        return $info if ! $self->{hasNetFreeDB};

        my $freedb = Net::FreeDB->new;
        my $discdata = $freedb->getdiscdata($file);
        return if !$discdata;
        my $cddb_file_object;
        my @results;

        foreach (@genres)
        {
            my $tmpCddb = $freedb->read($_, $discdata->{ID});
            if ($tmpCddb)
            {
                $tmpCddb->{genre} = $tmpCddb->genre || $_;
                push @results, $tmpCddb;
            }
        }
        
        if ($#results == -1)
        {
            return;
        }
        elsif ($#results == 0)
        {
            $cddb_file_object = $results[0];
        }
        else
        {
            my $dialog = new GCExtractMusicsResultsDialog(
                $self->{parent},
                $self->{model}
            );
            $dialog->setData(@results);
            my $selected = $dialog->show;
            $dialog->destroy;
            return if $selected == -1;
            $cddb_file_object = $results[$selected];
        }

        foreach my $track ($cddb_file_object->tracks)
        {
            $self ->addTrack($track->title,$track->length,$track->number);
        }

        $info->{tracks} = $self->getTracks;
        $info->{running} = $self->getTotalTime;
        $info->{title} = $cddb_file_object->title;
        $info->{artist} = $cddb_file_object->artist;
        $info->{release} = $cddb_file_object->year;
        $info->{genre} = $cddb_file_object->{genre};
        
        return $info;
    }

    sub addFirstTrackInfo
    {
        my ($self, $info) = @_;
 
        if ($^O =~ /win32/i)
        {
            $self->{firstTrack} =~ s|\\|/|g;
            $self->{fileName} =~ /^(.{2})/;
            my $drive = $1;
            $self->{firstTrack} = $drive.$self->{firstTrack}
                if $self->{firstTrack} =~ m|^/|;
        }

        if ($self->{firstTrack} =~ /mp3$/i)
        {
            if ($self->{hasMP3Info})
            {
                MP3::Info::use_mp3_utf8(1);
                my $song = MP3::Info::get_mp3tag($self->{firstTrack});
                $info->{title} = $song->{ALBUM};
                $info->{artist} = $song->{ARTIST};
                $info->{release} = $song->{YEAR};
                $info->{genre} = $song->{GENRE};
            }
            elsif ($self->{hasMP3Tag})
            {
                my $song = MP3::Tag->new($self->{firstTrack});
                (undef, undef, $info->{artist}, $info->{title}) = $song->autoinfo;
            }
        }
        elsif ($self->{firstTrack} =~ /ogg$/i)
        {
            if ($self->{hasOggVorbisHeader})
            {
                my $song = Ogg::Vorbis::Header::PurePerl->new($self->{firstTrack});
                $info->{title} = ($song->comment('album'))[0];
                $info->{artist} .= $_.', ' foreach $song->comment('artist');
                $info->{artist} =~ s/, $//;
                ($info->{release} = ($song->comment('date'))[0]) =~ s|^(\d{4})-(\d{2})-(\d{2}).*$|$3/$2/$1|;
                $info->{genre} .= $_.', ' foreach $song->comment('genre');
                $info->{genre} =~ s/, $//;
            }
        }
    }

    sub getInfo
    {
        my $self = shift;
        my $info = {};
        $self->resetTracks;

        if ((!$self->{fileName}) || ($self->{fileName} =~ /\/dev\//))
        {
            if (!$self->{fileName})
            {
                $self->{fileName} = $self->{parent}->{options}->cdDevice;
            }
            $info = $self->getFreeDB;
        }
        else
        {

            open FILE, '<'.$self->{fileName};
            binmode FILE;

            $self->{file} = \*FILE;
            my $header = <FILE>;
        
            $info = $self->getM3UInfo
                if ($self->{fileName} =~ /m3u$/) || ($header =~ /^#EXTM3U/);
            $info = $self->getPLSInfo
                if ($self->{fileName} =~ /pls$/) || ($header =~ /^\[playlist\]/);
            close FILE;
        }

        $self->addFirstTrackInfo($info);

        return if !defined $info;
        my $result;
        my $firstTrackName = $info->{tracks}->[0]->[1];
        $result->{tracks} = {displayed => $firstTrackName, value => $info->{tracks}};
        foreach (@{$self->{fields}})
        {
            next if /^tracks$/;
            $result->{$_} = {displayed => $info->{$_}, value => $info->{$_}};
        }
        return $result;
    }
    
    sub getFields
    {
        my $self = shift;
        return $self->{fields};
    }
}

1;
