package GCExtract::GCExtractFilms;

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

{
    package GCExtract::GCfilmsExtracter;
    use base 'GCItemExtracter';
    
    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new(@_);
        bless ($self, $class);

        return $self;
    }
    
    sub readInt
    {
        my ($self, $size) = @_;
        my $buf;

        $size = 4 if !$size;

        read $self->{file},$buf,$size;
        return unpack "i",$buf;
    }
    
    sub getAviInfo
    {
        my $self = shift;
        
        my $info = {};
        
        my @audioCodecs;
        $audioCodecs[0x0001] = 'PCM';
        $audioCodecs[0x0002] = 'ADPCM';
        $audioCodecs[0x0030] = 'Dolby AC2';
        $audioCodecs[0x0050] = 'MPEG';
        $audioCodecs[0x0055] = 'MP3';
        $audioCodecs[0x0092] = 'Dolby AC3 SPDIF';
        $audioCodecs[0x2000] = 'Dolby AC3';
        $audioCodecs[0x2001] = 'Dolby DTS';
        $audioCodecs[0x2002] = 'WAVE';
        $audioCodecs[0x2003] = 'WAVE';
        $audioCodecs[0x2004] = 'WAVE';
        $audioCodecs[0x2005] = 'WAVE';
        $audioCodecs[0x674F] = 'Ogg Vorbis',
        $audioCodecs[0x6750] = 'Ogg Vorbis',
        $audioCodecs[0x6751] = 'Ogg Vorbis',
        $audioCodecs[0x676F] = 'Ogg Vorbis',
        $audioCodecs[0x6770] = 'Ogg Vorbis',
        $audioCodecs[0x6771] = 'Ogg Vorbis',
        
        my $chunkName;
        seek $self->{file},8,0;
        read $self->{file},$chunkName,8;
        return $info if ($chunkName ne 'AVI LIST');
        seek $self->{file},4,1;
        read $self->{file},$chunkName,8;
        
        $self->readInt;
        my $dwMicroSecPerFrame = $self->readInt;
        my $dwMaxBytesPerSec = $self->readInt;
        my $dwReserved1 = $self->readInt;
        my $dwFlags = $self->readInt;
        my $dwTotalFrames = $self->readInt;
        my $dwInitialFrames = $self->readInt;
        my $dwStreams = $self->readInt;
        my $dwSuggestedBufferSize = $self->readInt;
        $info->{width} = $self->readInt;
        $info->{height} = $self->readInt;
        my $dwScale = $self->readInt;
        my $dwRate = $self->readInt;
        my $dwStart = $self->readInt;
        my $dwLength = $self->readInt;

        $info->{length} = ($dwTotalFrames * $dwMicroSecPerFrame) / 60000000;
        $info->{length} = GCUtils::round($info->{length});

        my $buff;
        my ($gotVids, $gotAuds) = (0,0);
        while (! eof($self->{file}))
        {
            read $self->{file},$chunkName,4;
            if ($chunkName eq 'strl')
            {
                seek $self->{file},8,1;
                read $self->{file},$buff,4;
                if ($buff eq 'vids')
                {
                    read $self->{file},$info->{type},4;
                    $gotVids = 1;
                }
                elsif ($buff eq 'auds')
                {
                    read $self->{file},$info->{audioEncoding},4;
                    $info->{audioEncoding} =~ s/^.*?\w*\W*?$/$1/g;
                    if (!$info->{audioEncoding})
                    {
                        read $self->{file},$chunkName,4 while ($chunkName ne 'strf');
                        seek $self->{file},4,1;
                        my $codec;
                        read $self->{file}, $codec, 2;
                        $codec = unpack "v",$codec;
                        $codec = $audioCodecs[$codec];
                        seek $self->{file}, 2, 1;
                        my $hz = $self->readInt;
                        $info->{audioEncoding} = $codec if $codec;
                        $info->{audioEncoding} .= " ($hz Hz)" if $hz;
                    }
                    $gotAuds = 1;
                }
                last if $gotVids && $gotAuds;
            }
            last if ($chunkName eq 'movi');
        }
        
        return {} if ($buff ne 'vids') && ($buff ne 'auds');

        return $info;
    }
    
    sub getMovAtom
    {
        my ($self, $wanted, $subAtom) = @_;
    
        my $copy = $subAtom;
    
        my ($header, $type, $length);
        my $atom = 0;
    
        if ($subAtom)
        {   
            while ($copy)
            {
                $header = substr($copy, 0, 8, '');
                ($length, $type) = unpack("Na4", $header);
                last if $type eq $wanted;
                substr($copy, 0 , $length - 8, '');
            }
            if ($copy)
            {
                $atom = substr($copy, 0 , $length - 8, '');
            }
        }
        else
        {
            while (!eof ($self->{file}))
            {
                read $self->{file}, $header, 8;
                ($length, $type) = unpack("Na4", $header);
                last if $type eq $wanted;
                seek $self->{file},$length - 8, 1;
            }
            if ($self->{file})
            {
                read $self->{file}, $atom, $length - 8;
            }
        }
        
        return $atom;
    }
    
    sub getMovInfo
    {
        #Inspired from Video::Info::Quicktime_PL
    
        my $self = shift;
        
        my $info = {};
        
        seek $self->{file},0,0;

        my $header;

        my $atom = $self->getMovAtom('moov');


        if ($atom)
        {
            while (length($atom) > 0)
            {
                my ($sublen) = unpack("Na4",  substr( $atom, 0, 4, '') );
                my ($subatom) = substr($atom, 0, $sublen-4, '');
                my($type)  = substr($subatom, 0, 4, '');
                
                if ($type eq 'mvhd')
                {
                    my $timeScale = unpack( "Na4", substr($subatom,12,4));  
                    my $duration = unpack( "Na4", substr($subatom,16,4));  
                    $info->{length} = GCUtils::round($duration / ($timeScale * 60));
                }
                elsif ($type eq 'trak')
                {
                    my $tkhd = $self->getMovAtom('tkhd', $subatom);
                    my $mdia = $self->getMovAtom('mdia', $subatom);
                    next if !$mdia;
                    my $minf = $self->getMovAtom('minf', $mdia);
                    next if !$minf;
                    my $vmhd = $self->getMovAtom('vmhd', $minf);
                    my $smhd = $self->getMovAtom('smhd', $minf);
                    if ($vmhd || $smhd)
                    {
                        my $stbl = $self->getMovAtom('stbl', $minf);
                        my $stsd = $self->getMovAtom('stsd', $stbl); 

                        if ($vmhd)
                        {
                            my $width = unpack("Na4", substr($tkhd,74,4));
                            my $height = unpack("Na4", substr($tkhd,78,4));
                            ($info->{width}, $info->{height}) = ($width, $height);
                            ($info->{type} = substr($stsd,12,8)) =~ s/\W(.*?)\W/$1/g;
                        }
                        else
                        {
                            ($info->{audioEncoding}= substr($stsd,12,8)) =~ s/\W(.*?)\W/$1/g;
                        }
                    }
                }
            }
        }        
        return $info;
    }
        
    sub getMpgInfo
    {
        #Inspired from MPEG::Info
    
        my $self = shift;
        
        my @frameRates = (
            0, 
            24000/1001,
            24,
            25,
            30000/1001,
            30,
            50,
            60000/1001,
            60,
        );
        
        my $info = {};
        $info->{type} = 'MPEG';
        $info->{audioEncoding} = 'MPEG';
        
        my $magic;
        my $numMagic = unpack("N",$self->{magic});
        while (!eof($self->{file}) && $numMagic != 0x000001b3)
        {
            read $self->{file},$magic,4;
            $numMagic = unpack("N",$magic);
            seek $self->{file},-3, 1;
        }
        seek $self->{file},3, 1;
        my $size;
        read $self->{file},$size,3;
        
        $info->{width} = ((unpack "n",substr($size,0,2)) >> 4);
        $info->{height} = ((unpack "n",substr($size,1,2)) & 0x0fff);
        
        my $fps;
        read $self->{file},$fps,1;
        $fps = $frameRates[ord($fps) & 0x0f];
        
        my ($buff1, $buff2);
        read $self->{file}, $buff1, 2;
        $buff1 = unpack 'n', $buff1;
        $buff1 <<= 2;
        read $self->{file}, $buff2, 1;
        $buff2 = unpack 'C', $buff2;
        $buff2 >>=6;
        my $bitRate = ( ( $buff1 | $buff2 ) * 400);
        
        $info->{length} = GCUtils::round((($self->{fileSize} * 8 ) / $bitRate) / 60) if $bitRate;
        
        return $info;
    }
    
    sub findOgmPage
    {
        #Inspired from Ogg::Vorbis::Header::PurePerl

        my $self = shift;
        my $char;
        my $curStr = '';

        my $i = 0;
        while (read($self->{file}, $char, 1))
        {
            $curStr = $char . $curStr;
            $curStr = substr($curStr, 0, 4);
        	if ($curStr eq 'SggO')
        	{
        	   seek $self->{file}, 8, 1;
        	   my $serial = $self->readInt(4);
        	   return $serial;
        	}
        }
        return -1;
    }

    sub findLastOgmPage
    {
        my $self = shift;
        my $buff;
        my $curStr = '';

        seek $self->{file}, -5, 2;

        my $i = 0;
        while (read($self->{file}, $buff, 4))
        {
        	if ($buff eq 'OggS')
        	{
        	   seek $self->{file}, 2, 1;
        	   my $granulePos = $self->readInt;
        	   return $granulePos;
        	}
        	seek $self->{file}, -5, 1;
        }
        return -1;
    }    
    
    sub getOgmInfo
    {
        my $info = {};
        my $self = shift;

        my $buff;
        my ($gotAudio, $gotVideo) = (0,0);
        seek $self->{file}, 0, 0;
        my $serial = 0;
        my $videoSerial = -1;
        my $fps;
        my $iteration = 0;
        while ($serial != -1)
        {
            $serial = $self->findOgmPage;

            seek $self->{file}, 13, 1;
            read $self->{file}, $buff, 8;
            if ($buff =~ /^video/)
            {
                read $self->{file}, $info->{type}, 4;
                my $size = $self->readInt;
                my $timeUnit = $self->readInt(8);
                my $spu = $self->readInt(8);
                $fps = (10000000.0 * $spu) / $timeUnit;
                my $defaultLen = $self->readInt;
                my $bufferSize = $self->readInt;
                my $bbp = $self->readInt;
                $info->{width} = $self->readInt;
                $info->{height} = $self->readInt;
                
                $gotVideo = 1;
                $videoSerial = $serial;
            }
            elsif ($buff =~ /vorbis/)
            {
                $info->{audioEncoding} = 'Vorbis';
                seek $self->{file}, 3, 1;
                my $hz = $self->readInt;
                $info->{audioEncoding} .= " ($hz Hz)" if $hz;
                $gotAudio = 1;
            }
            else
            {
                last if $iteration > 5;
            }
            last if $gotAudio && $gotVideo;
            $iteration++;
        }
        if ($gotVideo)
        {
            my $biggestGranulePos = $self->findLastOgmPage;
            $info->{length} = GCUtils::round(($biggestGranulePos / $fps) / 60);
        }
        
        return $info;
    }
    
    sub getInfo
    {
        my $self = shift;
   
        open FILE, '<'.$self->{fileName};
        binmode FILE;

        my $info = {};

        $self->{file} = \*FILE;
        my $magic;
        $self->{magic} = $magic;
        read FILE,$magic,4;
        my $numMagic = unpack("N",$magic);
                
        if ($magic eq 'RIFF')
        {
            $info = $self->getAviInfo;
        }
        elsif ($magic eq 'OggS')
        {
            $info = $self->getOgmInfo;
        }
        elsif (($numMagic == 0x000001ba) || ($numMagic == 0x000001b3))
        {
            $info = $self->getMpgInfo;
        }
        else
        {
            my $magic2;
            read FILE,$magic2,4;
            if ($magic2 =~ /(moov|notp|wide|ftyp)/)
            {
                $info = $self->getMovInfo;
            }
        }
        
        close FILE;
        my $result;
        
        $result->{time} = {displayed => $info->{length}, value => $info->{length}};
        $result->{video} = {displayed => $info->{type}, value => $info->{type}};
        my $currentAudio = $self->{panel}->audio;
        if ($info->{audioEncoding})
        {
            $currentAudio->[0]->[1] = $info->{audioEncoding};
            $result->{audio}->{value} = $currentAudio;
            $result->{audio}->{displayed} = $info->{audioEncoding};
        }
        if ($info->{width} && $info->{height})
        {
            my $comment = $self->{panel}->comment;
            $comment .= "\n" if $comment && ($comment !~ /\n$/m);
            $result->{comment}->{displayed} = 
                $self->{model}->getDisplayedText('ExtractSize').$self->{parent}->{lang}->{Separator}.
                $info->{width}.'*'.$info->{height};
            $result->{comment}->{value} = $comment . $result->{comment}->{displayed};
        }
        
        return $result;
    }
    
    sub getFields
    {
        return ['time', 'video', 'audio', 'comment'];
    }
}

1;
