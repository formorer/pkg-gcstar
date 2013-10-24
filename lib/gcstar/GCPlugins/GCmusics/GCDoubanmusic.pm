package GCPlugins::GCmusics::GCDoubanmusic;

###################################################
#
#  Copyright 2005-2010 Bai Wensimi
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

use GCPlugins::GCmusics::GCmusicsCommon;

{
    package GCPlugins::GCmusics::GCPluginDoubanmusic;

    use base qw(GCPlugins::GCmusics::GCmusicsPluginsBase);
    use XML::Simple;
    use Encode;
	use LWP::Simple qw($ua);

    sub parse
    {
        my ($self, $page) = @_;
		return if (($page =~ /^bad isbn/) & ($page =~ /^The/));
        my $xml;
        my $xs = XML::Simple->new;

        if ($self->{parsingList})
        {
			if ($page =~ /feed>$/)
			{
				$xml = $xs->XMLin(
                    $page,
					forceArray=>['author'],
                    KeyAttr    => ['']
                );
				foreach my $ItemMusic ( @{$xml->{'entry'}}){
					$self->{itemIdx}++;
					$self->{itemsList}[ $self->{itemIdx} ]->{'url'}  = $ItemMusic->{'id'};
					$self->{itemsList}[ $self->{itemIdx} ]->{'title'}  = $ItemMusic->{'title'};
					foreach my $tmp_author (@{$ItemMusic->{'author'}}){
						{($self->{itemsList}[ $self->{itemIdx} ]->{'artist'} ne '' ) and $self->{itemsList}[ $self->{itemIdx} ]->{'artist'}.=',';}
						$self->{itemsList}[ $self->{itemIdx} ]->{'artist'}.=$tmp_author->{'name'};
					}
				}
			}
			else
			{
				$xml = $xs->XMLin(
                    $page,
					forceArray=>['author'],
                    KeyAttr    => ['']
                );
				$self->{itemIdx}++;
				$self->{itemsList}[ $self->{itemIdx} ]->{'url'}  = $xml->{'id'};
				$self->{itemsList}[ $self->{itemIdx} ]->{'title'}  = $xml->{'title'};
				foreach my $tmp_author (@{$xml->{'author'}}){
						$self->{itemsList}[ $self->{itemIdx} ]->{'artist'}.=$tmp_author->{'name'};
						$self->{itemsList}[ $self->{itemIdx} ]->{'artist'}.=',';
				}
			}
        }
        else
        {
				$xml =$xs->XMLin($page,
					ForceArray => [ 'author' ],
					KeyAttr => {'db:tag'=>'name','link'=>'rel'});
			foreach my $tmp_author (@{$xml->{'author'}}){
					{($self->{curInfo}->{artist} ne '' ) and $self->{curInfo}->{artist}.=','; }
					$self->{curInfo}->{artist}.=$tmp_author->{'name'};
			}
			$self->{curInfo}->{title}=$xml->{'title'};
			$self->{curInfo}->{web}=$xml->{'link'}->{'alternate'}->{'href'};
			foreach my $check(@{$xml->{'db:attribute'}}){
				my $db_attr=$check->{'name'};
				SWITCH: {
					$db_attr eq 'publisher' and $self->{curInfo}->{producer}=$check->{'content'} ,last;
					$db_attr eq 'pubdate' and $self->{curInfo}->{release}=$check->{'content'} ,last;
					$db_attr eq 'ean' and $self->{curInfo}->{unique}=$check->{'content'} ,last;
					$db_attr eq 'media' and $self->{curInfo}->{format}=$check->{'content'} ,last;
					if ($db_attr eq 'tracks') { my @chains = split(/(?=\d+\.)/, $check->{'content'});
					foreach my $track ( @chains ){
							my $num=$track;my $name=$track;
							$num=~ s/(^\d+).*/$1/;
							$num=~ s/\n//g;
							$name =~ s/^\d+\.(.*)/$1/;
							$name=~s/\n//g;
							$num=encode("utf8",$num);
							$name=encode("utf8",$name);
							$self->addTrack($name,0,$num);
							}
						last SWITCH;}
					;
				}
			}
			$self->{curInfo}->{tracks} = $self->getTracks;
			my $tmp_image=$xml->{'link'}->{'image'}->{'href'};
			$tmp_image =~ s/spic/lpic/;
			$self->{curInfo}->{cover}=$tmp_image;
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
            artist => 1,
            publication => 0,
        };
        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        return $html;
    }

    sub getSearchUrl
    {
		my ($self, $word) = @_;
        return "http://api.douban.com/music/subjects?q=" .$word;
	}
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
        return $url;
    }	
    
    sub changeUrl
    {
        my ($self, $url) = @_;
        # Make sure the url is for the api, not the main movie page
        return $self->getItemUrl($url);
    }

    sub getNumberPasses
    {
        return 1;
    }

    sub getName
    {
        return "豆瓣";
    }
    

    sub testURL
    {
        my ($self, $url) = @_;
        $url =~ /[\?&]lid=([0-9]+)*/;
        my $id = $1;
        return ($id == $self->siteLanguageCode());
    }

    sub getReturnedFields
    {
        my $self = shift;

            $self->{hasField} = {
                title => 1,
                artist => 1,
            };
    }
    
    sub getAuthor
    {
        return 'BW';
    }
    
    sub getLang
    {
        return 'ZH';
    }
    
    sub isPreferred
    {
        return 1;
    }
    
    sub getSearchCharset
    {
        my $self = shift;
        
        # Need urls to be double character encoded
        return "UTF-8";
    }
	    sub getSearchFieldsArray
    {
        return ['isbn', 'title'];
    }

    sub getCharset
    {
        my $self = shift;
    
        return "UTF-8";
    }

    sub decodeEntitiesWanted
    {
        return 0;
    } 

    sub siteLanguage
    {
        my $self = shift;
        
        return 'ZH';
    }
    
}

1;
