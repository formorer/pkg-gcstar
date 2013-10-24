package GCExport::GCExportTellico;

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

use GCExport::GCExportBase;

{
    package GCExport::GCExporterTellico;

    use base qw(GCExport::GCExportBaseClass);
    use GCUtils;

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->checkModule('MIME::Base64');
        $self->checkModule('Digest::MD5');

        #List of collections: http://www.periapsis.org/tellico/doc/collection-type-values.html
        # [ entryTitle, type, extra fields ]
        $self->{models} = {
                              GCbooks  => ['Books', '2', ''],
                              GCfilms  => ['Videos', '3', '<field flags="2" title="Rating" category="Personal" allowed="5;4;3;2;1" format="4" type="3" name="rating" />'],
                              GCmusics => ['Music', '4', ''],
                              GCcoins  => ['Coin', '8', ''],
                              GCgames  => ['Games', '11', '']
                          };
        
        return $self;
    }

    sub getName
    {
        my $self = shift;
        
        return "Tellico";
    }
    
    sub getModels
    {
        my $self = shift;
        
        my @models = keys %{$self->{models}};
        return \@models;
    }
    
    sub needsUTF8
    {
        my $self = shift;
    
        return 1;
    }

    sub getOptions
    {
        my $self = shift;
        
        return [];
    }
      
    sub wantsFieldsSelection
    {
        return 0;
    }
    
    sub preProcess
    {
        my $self =  shift;
        
        $self->{imagesInfos} = {};
        return 1;
    }

    sub getHeader
    {
        my ($self, $number) = @_;
        my $result;

        my $model = $self->{model};
        my $title = $model->getDescription;
        my $info = $self->{models}->{$model->getName};

        $result = '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE tellico PUBLIC "-//Robby Stephenson/DTD Tellico V9.0//EN" "http://periapsis.org/tellico/dtd/v9/tellico.dtd">
<tellico xmlns="http://periapsis.org/tellico/" syntaxVersion="7" >
 <collection title="'.$title.'" entryTitle="'.$info->[0].'" type="'.$info->[1].'" >
  <fields>
   <field name="_default" />
   '.$info->[2].'
  </fields>
';

        return $result;
    }
    
    sub transformData
    {
        my ($self, $data) = @_;
        
        $data =~ s/&/&amp;/g;
        
        return $data;
    }
    
    sub transformList
    {
        my ($self, $list, $tag) = @_;

        my $result = '';
        if (ref($list) eq 'ARRAY')
        {
            foreach (@{$list})
            {
                $result .= "    <$tag>".$self->transformData($_->[0])
                        ."</$tag>\n";
            }
        }
        else
        {
            foreach (split ',', $list)
            {
                s/;.*$//;
                $result .= "    <$tag>".$self->transformData($_)."</$tag>\n";
            }
        }
        return $result;
    }
    
    sub encodeImage
    {
        my ($self, $file) = @_;
        my $image = GCUtils::getDisplayedImage($file, $self->{options}->{defaultImage}, $self->{original});
        (my $suffix = $image) =~ s/.*?\.([^.]*)$/$1/;
        $suffix = 'jpeg' if $suffix eq 'jpg';
        open PIC, "<$image" or return (undef,undef,undef);
        my $data = do {local $/; <PIC>};
        close PIC;
        my $pictureId = Digest::MD5::md5_hex($data).'.'.$suffix;
        my %infos;
        $infos{id} = $pictureId;
        $infos{format} = uc $suffix;
        $infos{width} = 120;
        $infos{height} = 160;
        $infos{data} = MIME::Base64::encode_base64($data);
        return \%infos;
    }

    sub getItem
    {
        my ($self, $item, $number) = @_;
        
        my $methodName = 'get'.$self->{model}->getName.'Item';
        
        return $self->$methodName($item);
    }
    
    sub getGCfilmsItem
    {
        my ($self, $movie, $number) = @_;
        my $result;
        
       #(my $synopsis = $movie->{synopsis}) =~ s/<br>/\n/gm;
       #(my $comments = $movie->{comment}) =~ s/<br>/\n/gm;
  
        use integer;
        my $rating = $movie->{rating} / 2;
        no integer;
        
        my $age = $movie->{age};
        my $certification;
        
        if ($age == 1)
        {
            $certification = 'U (USA)';
        }
        elsif ($age == 2)
        {
            $certification = 'G (USA)';
        }
        elsif ($age <= 5)
        {
             $certification = 'PG (USA)';
        }
        elsif ($age <= 13)
        {
            $certification = 'PG-13 (USA)';
        }
        elsif ($age <= 17)
        {
            $certification = 'R (USA)';
        }

        my $imageInfos = $self->encodeImage($movie->{image});
        $self->{imagesInfos}->{$imageInfos->{id}} = $imageInfos;

        my $year = GCPreProcess::extractYear($movie->{date});

        $result = '  <entry>
   <title>'.$self->transformData($movie->{title}).'</title>
   <medium>'.$self->transformData($movie->{format}).'</medium>
   <year>'.$year.'</year>
   <certification>'.$certification.'</certification>
   <genres>
';
        $result .= $self->transformList($movie->{genre}, 'genre');
        $result .= '   </genres>
   <nationalitys>
    <nationality>'.$self->transformData($movie->{country}).'</nationality>
   </nationalitys>
   <casts>
';
        foreach (split ',', $movie->{actors})
        {
            $result .= "    <cast><column>".$self->transformData($_)."</column></cast>\n";
        }
        $result .= '   </casts>
   <directors>
    <director>'.$self->transformData($movie->{director}).'</director>
   </directors>
   <languages>
';
        $result .= $self->transformList($movie->{audio}, 'language');
        $result .= '   </languages>
   <running-time>'.$self->transformData($movie->{time}).'</running-time>
   <plot>'.$self->transformData($movie->{synopsis}).'</plot>
   <rating>'.$rating.'</rating>
   <comments>'.$self->transformData($movie->{comments}).'</comments>
';
        if (($movie->{borrower}) && ($movie->{borrower} ne 'none'))
        {
            $result .= '   <loaned>true</loaned>
';
        }
        
        $result .= '   <cover>'.$imageInfos->{id}.'</cover>
';
        
        $result .= '  </entry>
';

        return $result;
    }
    
    sub getGCgamesItem
    {
        my ($self, $item, $number) = @_;
        my $result;
        
        use integer;
        my $rating = $item->{rating} / 2;
        no integer;

        my $imageInfos = $self->encodeImage($item->{boxpic});
        $self->{imagesInfos}->{$imageInfos->{id}} = $imageInfos;

        my $year = GCPreProcess::extractYear($item->{released});

        $result = '  <entry>
   <title>'.$self->transformData($item->{name}).'</title>
   <platform>'.$self->transformData($item->{platform}).'</platform>
   <description>'.$self->transformData($item->{description}).'</description>
   <year>'.$year.'</year>
   <pur_date>'.$self->transformData($item->{added}).'</pur_date>
   <genres>
';
        $result .= $self->transformList($item->{genre}, 'genre');
        $result .= '   </genres>
   <publishers>
    <publisher>'.$self->transformData($item->{editor}).'</publisher>
   </publishers>
   <rating>'.$rating.'</rating>
';
        if (($item->{borrower}) && ($item->{borrower} ne 'none'))
        {
            $result .= '   <loaned>true</loaned>
';
        }
        if ($item->{completion} >= 100)
        {
            $result .= '   <completed>true</completed>
';
        }
        
        $result .= '   <cover>'.$imageInfos->{id}.'</cover>
';
        
        $result .= '  </entry>
';

        return $result;
    }

    sub getGCbooksItem
    {
        my ($self, $item, $number) = @_;
        my $result;
        
        use integer;
        my $rating = $item->{rating} / 2;
        no integer;

        my $imageInfos = $self->encodeImage($item->{cover});
        $self->{imagesInfos}->{$imageInfos->{id}} = $imageInfos;

        my $year = GCPreProcess::extractYear($item->{publication});

        $result = '  <entry>
   <title>'.$self->transformData($item->{title}).'</title>
   <isbn>'.$self->transformData($item->{isbn}).'</isbn>
   <series>'.$self->transformData($item->{serie}).'</series>
   <edition>'.$self->transformData($item->{edition}).'</edition>
   <binding>'.$self->transformData($item->{format}).'</binding>
   <comments>'.$self->transformData($item->{description}).'</comments>
   <pages>'.$self->transformData($item->{pages}).'</pages>
   <pur_date>'.$self->transformData($item->{acquisition}).'</pur_date>
   <pub_year>'.$year.'</pub_year>
   <publisher>'.$self->transformData($item->{publisher}).'</publisher>
   <authors>
';
        $result .= $self->transformList($item->{authors}, 'author');
        $result .= '   </authors>
   <languages>
';
        $result .= $self->transformList($item->{language}, 'language');
        $result .= '   </languages>
   <genres>
';
        $result .= $self->transformList($item->{genre}, 'genre');
        $result .= '   </genres>
   <rating>'.$rating.'</rating>
';
        if (($item->{borrower}) && ($item->{borrower} ne 'none'))
        {
            $result .= '   <loaned>true</loaned>
';
        }
        if ($item->{read})
        {
            $result .= '   <read>true</read>
';
        }
        
        $result .= '   <cover>'.$imageInfos->{id}.'</cover>
';
        
        $result .= '  </entry>
';

        return $result;
    }

    sub getGCmusicsItem
    {
        my ($self, $item, $number) = @_;
        my $result;
        
        use integer;
        my $rating = $item->{rating} / 2;
        no integer;

        my $imageInfos = $self->encodeImage($item->{cover});
        $self->{imagesInfos}->{$imageInfos->{id}} = $imageInfos;

        my $year = GCPreProcess::extractYear($item->{release});

        $result = '  <entry>
   <title>'.$self->transformData($item->{title}).'</title>
   <medium>'.$self->transformData($item->{format}).'</medium>
   <year>'.$year.'</year>
   <label>'.$self->transformData($item->{label}).'</label>
   <comments>'.$self->transformData($item->{comment}).'</comments>
   <artists>
';
        $result .= $self->transformList($item->{artist}, 'artist');
        $result .= '   </artists>
   <genres>
';
        $result .= $self->transformList($item->{genre}, 'genre');
        $result .= '   </genres>
   <rating>'.$rating.'</rating>
   <tracks>';
        foreach (@{$item->{tracks}})
        {
            $result .= '
      <track>
         <column>'.$self->transformData($_->[1]).'</column>
         <column>'.$self->transformData($item->{artist}).'</column>
         <column>'.$self->transformData($_->[2]).'</column>
      </track>'
        }
        $result .= '
   </tracks>
';


        if (($item->{borrower}) && ($item->{borrower} ne 'none'))
        {
            $result .= '   <loaned>true</loaned>
';
        }
        $result .= '   <cover>'.$imageInfos->{id}.'</cover>
';
      
        $result .= '  </entry>
';

        return $result;
    }

    sub getGCcoinsItem
    {
        my ($self, $item, $number) = @_;
        my $result;
        
        my $frontInfos = $self->encodeImage($item->{front});
        $self->{imagesInfos}->{$frontInfos->{id}} = $frontInfos;
        my $backInfos = $self->encodeImage($item->{back});
        $self->{imagesInfos}->{$backInfos->{id}} = $backInfos;

        $result = '  <entry>
   <title>'.$self->transformData($item->{name}).'</title>
   <type>'.$self->transformData($item->{currency}).'</type>
   <denomination>'.$self->transformData($item->{value}).'</denomination>
   <year>'.$self->transformData($item->{year}).'</year>
   <country>'.$self->transformData($item->{country}).'</country>
   <set>'.(($item->{type} eq 'coin') ? 'true' : 'false').'</set>
   <pur_date>'.$self->transformData($item->{added}).'</pur_date>
   <pur_price>'.$self->transformData($item->{estimate}).'</pur_price>
   <location>'.$self->transformData($item->{location}).'</location>
   <comments>'.$self->transformData($item->{comments}).'</comments>
   <obverse>'.$frontInfos->{id}.'</obverse>
   <reverse>'.$backInfos->{id}.'</reverse>
  </entry>
';
        return $result;
    }

    sub getFooter
    {
        my $self = shift;
        my $result;
        
        $result = '  <images>
';
        foreach (values %{$self->{imagesInfos}})
        {
            $result .= '   <image id="'.$_->{id}.'" format="'.$_->{format}.
                       '" width="'.$_->{width}.'" height="'.$_->{height}.'">'.
                       $_->{data}.'</image>';
        }
        $result .='  </images>
 </collection>
</tellico>
';
        
        return $result;
    }

    # postProcess
    # Called after all processing. Use it if you need to perform extra stuff on the header.
    # $header is a reference to the header string.
    sub postProcess
    {
        my ($self, $header, $body) = @_;

        # Your code here
        # As header is a reference, it can be modified on place with $$header
    }

    # getEndInfo
    # Used to display some information to user when export is ended.
    # To localize your message, use $self->{options}->{lang}.
    # Returns a string that will be displayed in a message box.
    sub getEndInfo
    {
        my $self = shift;
        my $message;
        
        # Your code here
        # Don't do put anything in message if you don't want information to be displayed.
        
        return $message;
    }
}

1;
