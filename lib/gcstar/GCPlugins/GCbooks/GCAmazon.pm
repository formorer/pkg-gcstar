package GCPlugins::GCbooks::GCAmazon;

###################################################
#
#  Copyright 2005-2009 Tian
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

use GCPlugins::GCbooks::GCbooksCommon;

{
    package GCPlugins::GCbooks::GCPluginAmazon;
    
    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use XML::Simple;
    use LWP::Simple qw($ua);
    use Encode;
    use HTML::Entities;
    use GCUtils;

    sub parse
    {
        my ($self, $page) = @_;
        return if $page =~ /^<!DOCTYPE html/;
        my $xml;
        my $xs = XML::Simple->new;

        if ($self->{parsingList})
        {
            $xml = $xs->XMLin($page, ForceArray => ['Item','Author'], KeyAttr => []);
            my $book;
            foreach $book ( @{ $xml -> {'Items'} -> {'Item'} })
            {
                $self->{itemIdx}++;
                my $url = $self->baseAWSUrl."&Operation=ItemLookup&ResponseGroup=Large,EditorialReview&ItemId=".$book->{ASIN};
                
                $self->{itemsList}[$self->{itemIdx}]->{url} = $url;
                $self->{itemsList}[$self->{itemIdx}]->{title} = $book->{ItemAttributes}->{'Title'};
                for my $author (@{$book->{ItemAttributes}->{'Author'}})
                {
                    $self->{itemsList}[$self->{itemIdx}]->{authors} .= ", "
                        if $self->{itemsList}[$self->{itemIdx}]->{authors};
                    $self->{itemsList}[$self->{itemIdx}]->{authors} .= $author;
                }
                $self->{itemsList}[$self->{itemIdx}]->{publication} = $book->{ItemAttributes}->{'PublicationDate'};
                $self->{itemsList}[$self->{itemIdx}]->{format} = $book->{ItemAttributes}->{'Binding'};
                $self->{itemsList}[$self->{itemIdx}]->{edition} = $book->{ItemAttributes}->{'Edition'};
            }
        }
        else
        {
            $xml = $xs->XMLin($page, ForceArray => ['Author','EditorialReview','Language'], KeyAttr => []);   
            $self->{curInfo}->{title} = $xml->{Items}->{Item}->{ItemAttributes}->{Title};
            for my $author (@{$xml->{Items}->{Item}->{ItemAttributes}->{Author}})
            {
                push @{$self->{curInfo}->{authors}}, [$author];
            }
            
            my $htmlDescription;
            if ($xml->{Items}->{Item}->{EditorialReviews}->{EditorialReview}[0]->{Content})
            {
                $htmlDescription = $xml->{Items}->{Item}->{EditorialReviews}->{EditorialReview}[0]->{Content};
            }
            else
            {
                # Unfortunately the api doesn't always return the product description, which is due to
                # copyright concerns or something. In this case, grab the product html and parse it for
                # the description.
                my $response = $ua->get($xml->{Items}->{Item}->{DetailPageURL});
                my $result;
                eval {
                    $result = $response->decoded_content;
                };
                
                # Replace some bad characters. TODO - will probably need to extend this for de/jp plugins
                $result =~ s|\x{92}|'|gi;
                $result =~ s|&#146;|'|gi;
                $result =~ s|&#149;|*|gi;
                $result =~ s|&#156;|oe|gi;
                $result =~ s|&#133;|...|gi;
                $result =~ s|\x{85}|...|gi;
                $result =~ s|\x{8C}|OE|gi;
                $result =~ s|\x{9C}|oe|gi;
                $result =~ s|&#252;|ü|g;
                $result =~ s|&#223;|ß|g;
                $result =~ s|&#246;|ö|g;
                $result =~ s|&#220;|Ü|g;
                $result =~ s|&#228;|ä|g;  
		        $result =~ s/&#132;/&#187;/gm;
		        $result =~ s/&#147;/&#171;/gm;                              
                
                # Chop out the product description
                $result =~ /<div class="productDescriptionWrapper">(.*?)<(\/)*?div/s;
                $htmlDescription = $1;
                
                # Decode
                decode_entities($htmlDescription);
                $htmlDescription = decode('ISO-8859-1', $htmlDescription);
            }
            
            # Replace some html with line breaks, strip out the rest
            $htmlDescription =~ s/<br>/\n/ig;
            $htmlDescription =~ s/<p>/\n\n/ig;
            $htmlDescription =~ s/<(.*?)>//gi;            
            $htmlDescription =~ s/^\s*//;
            $htmlDescription =~ s/\s*$//;         
            $htmlDescription =~ s/ {1,}/ /g;   
            $self->{curInfo}->{description} = $htmlDescription;
            
            $self->{curInfo}->{publisher} = $xml->{Items}->{Item}->{ItemAttributes}->{Publisher}
                if (!ref($xml->{Items}->{Item}->{ItemAttributes}->{Publisher}));
            $self->{curInfo}->{publication} = $xml->{Items}->{Item}->{ItemAttributes}->{PublicationDate}
                if (!ref($xml->{Items}->{Item}->{ItemAttributes}->{PublicationDate}));
            $self->{curInfo}->{language} = $xml->{Items}->{Item}->{ItemAttributes}->{Languages}->{Language}[0]->{Name}
                if (ref($xml->{Items}->{Item}->{ItemAttributes}->{Languages}->{Language}));
            $self->{curInfo}->{pages} = $xml->{Items}->{Item}->{ItemAttributes}->{NumberOfPages}
                if (!ref($xml->{Items}->{Item}->{ItemAttributes}->{NumberOfPages}));
            $self->{curInfo}->{isbn} = $xml->{Items}->{Item}->{ItemAttributes}->{EAN}
                if (!ref($xml->{Items}->{Item}->{ItemAttributes}->{EAN}));
            $self->{curInfo}->{format} = $xml->{Items}->{Item}->{ItemAttributes}->{Binding}
                if (!ref($xml->{Items}->{Item}->{ItemAttributes}->{Binding}));
            $self->{curInfo}->{edition} = $xml->{Items}->{Item}->{ItemAttributes}->{Edition}
                if (!ref($xml->{Items}->{Item}->{ItemAttributes}->{Edition}));
            $self->{curInfo}->{web} = $xml->{Items}->{Item}->{DetailPageURL};

            # Genre handling via Amazon's browsenodes. Stupidly complicated way of doing things, IMO
            # Loop through all the nodes:
            for my $node (@{$xml->{Items}->{Item}->{BrowseNodes}->{BrowseNode}})
            {
                my $genre = '';
                my $ancestor = $node;
                
                # Push the lowest node to the temporary genre list
                my @genre_list = ($node->{Name});
                
                # Start stepping down through the current node to find it's children
                while ($ancestor->{Ancestors}->{BrowseNode})
                {
                    $ancestor = $ancestor->{Ancestors}->{BrowseNode};
                    if (($ancestor->{Name} eq 'Specialty Stores') ||
                        ($ancestor->{Name} eq 'Refinements') || 
                        ($ancestor->{Name} eq 'Self Service') || 
                        ($ancestor->{Name} eq 'Specialty Boutique'))
                    {
                        # Some categories we definetly want to ignore, since they are full of rubbish tags
                        $genre = 'ignore';
                        last;
                    }
                    elsif ($ancestor->{Name} =~ m/A\-Z/) 
                    {
                        # Clear out the current genres from the node, will be full of rubbish like "Authors A-K"
                        # Keep looping afterwards though, since there could be valid tags below the author
                        # specific ones
                        undef(@genre_list);
                    }
                    elsif ($ancestor->{Name} eq 'Subjects')
                    {
                        # Don't go deeper than a Subjects node
                        last;
                    }
                    else
                    {
                        # Add the current node to the temporary list, if it's not already included in either list
                        push @genre_list, $ancestor->{Name}
                            if ((!GCUtils::inArrayTest($ancestor->{Name}, @genre_list)) && 
                                (!GCUtils::inArrayTest($ancestor->{Name}, @{$self->{curInfo}->{genre}})));
                    }
                }
                
                if ($genre ne 'ignore')
                {               
                    # Add temporary list to item info
                    push @{$self->{curInfo}->{genre}}, [$_] foreach @genre_list;
                }
            }   
            
            # Let's sort the list for good measure
            @{$self->{curInfo}->{genre}} = sort @{$self->{curInfo}->{genre}};
            

            # Fetch either the big original pic, or just the small thumbnail pic
            if ($self->{bigPics})
            {
                $self->{curInfo}->{cover} = $xml->{Items}->{Item}->{LargeImage}->{URL};
            }
            else
            {
                $self->{curInfo}->{cover} = $xml->{Items}->{Item}->{SmallImage}->{URL};
            }
        }
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            title => 1,
            authors => 1,
            publication => 1,
            format => 1,
            edition => 1,
        };

        return $self;
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
        if (!$url)
        {
            # If we're not passed a url, return a hint so that gcstar knows what type
            # of addresses this plugin handles
            $url = "http://".$self->baseWWWamazonUrl();
        }
        elsif ($url !~ m/sowacs.appspot.com/)
        {        
            # Convert amazon url to aws url
            $url =~ /\/dp\/(\w*)[\/|%3F]/;
            my $asinid = $1;
            $url = $self->baseAWSUrl."&Operation=ItemLookup&ResponseGroup=Large,EditorialReview&ItemId=".$asinid;
        }
        return $url;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        return $html;
    }
    
    sub decodeEntitiesWanted
    {
        return 0;
    }

    sub getSearchUrl
    {
		my ($self, $word) = @_;		

        my $key = 
            ($self->{searchField} eq 'authors') ? 'Author' :
            ($self->{searchField} eq 'title')   ? 'Title' :
            ($self->{searchField} eq 'isbn')    ? 'Keywords' :
                                                  '';
       $word =~ s/\D//g
            if $key eq 'Keywords';
		return $self->baseAWSUrl."&Operation=ItemSearch&$key=$word&SearchIndex=Books&ResponseGroup=Medium";
    }
    
    sub baseAWSUrl
    {	
        my $self = shift;
		return "http://sowacs.appspot.com/AWS/%5Bamazon\@gcstar.org%5D".$self->baseAmazonUrl()."/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=AKIAJJ5TJWI62A5OOTQQ&AssociateTag=AKIAJJ5TJWI62A5OOTQQ";
    }
    
    sub baseAmazonUrl
    {
		return "ecs.amazonaws.com";    
    }
    
    sub baseWWWamazonUrl
    {   
		return "www.amazon.com";    
    }    
    
    sub changeUrl
    {
        my ($self, $url) = @_;
        # Make sure the url is for the api, not the main movie page
        return $self->getItemUrl($url);
    }

    sub getName
    {
        return "Amazon (US)";
    }
    
    sub getAuthor
    {
        return 'Zombiepig';
    }
    
    sub getLang
    {
        return 'EN';
    }

    sub getCharset
    {
        my $self = shift;
    
        return "UTF-8";
    }
    
    sub getSearchCharset
    {
        my $self = shift;
        
        # Need urls to be double character encoded
        return "utf8";
    }

    sub convertCharset
    {
        my ($self, $value) = @_;
        return $value;
    }

    sub getNotConverted
    {
        my $self = shift;
        return [];
    }

    sub isPreferred
    {
        return 1;
    }
    
    sub getSearchFieldsArray
    {
        return ['title', 'authors', 'isbn'];
    }

}

1;
