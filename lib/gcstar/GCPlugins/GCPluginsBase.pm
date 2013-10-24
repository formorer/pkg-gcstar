package GCPlugins::GCPluginsBase;

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

{
    package GCPluginParser;
    use base qw(HTML::Parser);
    use LWP::Simple qw($ua);
    use HTTP::Cookies::Netscape;
    use URI::Escape;
    use HTML::Entities;
    use Encode;
    use File::Spec;
    

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();

        $ua->agent('Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.5) Gecko/20041111 Firefox/1.0');
        $ua->default_header('Accept-Encoding' => 'x-gzip');
        $ua->default_header('Accept' => 'text/html');
        $self->{ua} = $ua;
        
        $self->{itemIdx} = -1;
        $self->{itemsList} = ();
        
        bless ($self, $class);
        return $self;
    }

    sub getItemsNumber
    {
        my ($self) = @_;

        return $self->{itemIdx} + 1;
    }

    sub getItems
    {
        my ($self) = @_;
        return @{$self->{itemsList}};
    }

    sub load
    {
        my $self = shift;
        
        $self->checkProxy;
        $self->checkCookieJar;
         
        $self->{itemIdx} = -1;
        $self->{isInfo} = 0;
        $self->{itemsList} = ();

        #my $word = uri_escape_utf8($self->{title});
        my $title2 = encode($self->getSearchCharset, $self->{title});
        my $word = uri_escape($title2);
        $word =~ s/%20/+/g;
        
        my $post;
        my $html;
        
        # For multi-pass plugins, the plugin will have set the url to load for 
        # the next pass as nextUrl. If this doesn't exist, we're either on the 
        # first pass, or only using a one-pass plugin, so call getSearchUrl
        # to find the url to retrieve
        if ($self->{nextUrl})
        {
            $html = $self->loadPage($self->{nextUrl});
        }
        else
        {
            $html = $self->loadPage($self->getSearchUrl($word));    
        }

        $self->{parsingList} = 1;
        $html = $self->preProcess($html);
        decode_entities($html)
            if $self->decodeEntitiesWanted;
        $self->{inside} = undef;
        $self->parse($html);
        
        my @noConversion = @{$self->getNotConverted};
        foreach my $item (@{$self->{itemsList}})
        {
            foreach (keys %{$item})
            {
                next if $_ eq 'url';
                $item->{$_} = $self->convertCharset($item->{$_})
                    if ! GCUtils::inArrayTest($_, @noConversion);
            }
        }

    }
    
    sub loadPage
    {
        my ($self, $url, $post, $noSave) = @_;
        my $debugPhase = $ENV{GCS_DEBUG_PLUGIN_PHASE};
        my $debugFile;
        $debugFile = File::Spec->tmpdir.'/'.GCUtils::getSafeFileName($url)
	       if ($debugPhase > 0);
        $self->{loadedUrl} = $url if ! $noSave;
        my $response;
        my $result;
        if ($debugPhase != 2)
        {
            if ($post)
            {
                $response = $ua->post($url, $post);
            }
            else
            {
                $response = $ua->get($url);
            }
            
			#UnclePetros 03/07/2011:
            #code to handle correctly 302 response messages
            my $label1 = $response->code;
            if($response->code == '302'){
            	my $location = $response->header("location");
            	$response = $ua->get($location);
            	$self->{loadedUrl} = $location;
            }
            
            eval {
                $result = $response->decoded_content;
            };
            if ($debugPhase == 1)
            {
                open DEBUG_FILE, ">$debugFile";
                print DEBUG_FILE ($result || $response->content);
                close DEBUG_FILE;
            }
        }
        else
        {
            local $/;
            open DEBUG_FILE, "$debugFile";
            $result = <DEBUG_FILE>;
            utf8::decode($result);
        }
        return $result || ($response && $response->content);
    }
    
    sub capWord
    {
        my ($self, $msg) = @_;
        
        use locale;
        
        (my $newmsg = lc $msg) =~ s/(\s|,|^)(\w)(\w)(\w*?)/$1\U$2\E$3$4/gi;
        return $newmsg;
    }

    sub getSearchFieldsArray
    {
        return [''];
    }

    sub getSearchFields
    {
        my ($self, $model) = @_;
        
        my $result = '';
        $result .= $model->getDisplayedLabel($_).', ' foreach (@{$self->getSearchFieldsArray});
        $result =~ s/, $//;
        return $result;
    }

    sub hasField
    {
        my ($self, $field) = @_;
    
        return $self->{hasField}->{$field};
    }

    sub getExtra
    {
        return '';
    }

    # Character set for web page text
    sub getCharset
    {
        my $self = shift;
    
        return "ISO-8859-1";
    }
    
    # Character set for encoding search term, can sometimes be different
    # to the page encoding, but we default to the same as the page set
    sub getSearchCharset
    {
        my $self = shift;
    
        return getCharset;
    }
    
    # For some plugins, we need extra checks to determine if urls match
    # the language the plugin is written for. This allows us to correctly determine
    # if a drag and dropped url is handled by a particular plugin. If these
    # checks are necessary, return 1, and make sure plugin handles the 
    # the testURL function correctly
    sub needsLanguageTest
    {
        return 0;
    }   
    
    # Used to test if a given url is handled by the plugin. Only required if 
    # needsLanguageTest is true.
    sub testURL
    {
        my ($self, $url) = @_;    
        return 1
    }
    
    # Determines whether plugin should be the default plugins gcstar uses.
    # Plugins with this attribute set will appear first in plugin list,
    # and will be highlighted with a star icon. A returned value of 1 
    # means the plugin is preferred if it's language matches the user's language,
    # a returned value of 2 mean's it's preferred regardless of the language.
    sub isPreferred
    {
        return 0;
    }
    
    sub getPreferred
    {
        return isPreferred;
    }
  	     
    sub getNotConverted
    {
        my $self = shift;
        return [];
    }

    sub decodeEntitiesWanted
    {
        return 1;
    }

    sub getDefaultPictureSuffix
    {
        return '';
    }

    sub convertCharset
    {
        my ($self, $value) = @_;

        my $result = $value;
        if (ref($value) eq 'ARRAY')
        {
            foreach my $line(@{$value})
            {
                my $i = 0;
                map {$_ = decode($self->getCharset, $_)} @{$line};
            }
        }
        else
        {
            eval {
                $result = decode($self->getCharset, $result);
            };
        }
        return $result;
    }
    
    sub getItemInfo
    {
        my $self = shift;

        eval {
            $self->init;
        };
        my $idx = $self->{wantedIdx};
        my $url = $self->getItemUrl($self->{itemsList}[$idx]->{url});
        $self->loadUrl($url);
        return $self->{curInfo};
    }
        
    sub changeUrl
    {
        my ($self, $url) = @_;

        return $url;
    }
    
    sub loadUrl
    {
        my ($self, $url) = @_;
        $self->checkProxy;
        $self->checkCookieJar;
        my $realUrl = $self->changeUrl($url);
        my $html = $self->loadPage($realUrl);
        $self->{parsingList} = 0;
        #$html = $self->convertCharset($html);
        $self->{curInfo} = {};

        $html = $self->preProcess($html);
        decode_entities($html)
            if $self->decodeEntitiesWanted;

        $self->{curInfo}->{$self->{urlField}} = $url;
        $self->{inside} = undef;
        $self->parse($html);

        my @noConversion = @{$self->getNotConverted};
        foreach (keys %{$self->{curInfo}})
        {
            next if $_ eq $self->{urlField};
            $self->{curInfo}->{$_} = $self->convertCharset($self->{curInfo}->{$_})
                if ! GCUtils::inArrayTest($_, @noConversion);
            if (ref($self->{curInfo}->{$_}) ne 'ARRAY')
            {
                $self->{curInfo}->{$_} =~ s/\|/,/gm;
                $self->{curInfo}->{$_} =~ s/\r//gm;
                $self->{curInfo}->{$_} =~ s/[ \t]*$//gm;
            }
        }
        $self->{curInfo}->{$self->{urlField}} .= $GCModel::linkNameSeparator.$self->getName;
        return $self->{curInfo};
    }

    sub setProxy
    {
		my ($self, $proxy) = @_;
		
		$self->{proxy} = $proxy;
    }
    
    sub checkProxy
    {
        my $self = shift;
        $ua->proxy(['http'], $self->{proxy});
        #$self->{ua}->proxy(['http'], $self->{proxy});
    }
    
    sub setCookieJar
    {
        my ($self, $cookieJar) = @_;
        $self->{cookieJar} = $cookieJar;  
    }

    sub checkCookieJar
    {
        my $self = shift;
        $ua->cookie_jar(HTTP::Cookies::Netscape->new(
          'file' => "$self->{cookieJar}",
          'autosave' => 1,));
    }

    # Used to set the number of passes the plugin requires
    sub getNumberPasses
    {
        # Most plugins only need to search once, so default to one pass
        return 1;
    }
    
    # Returns undef if it doesn't support search using barcode scanner
    sub getEanField
    {
        return undef;
    }
    
}

1;
