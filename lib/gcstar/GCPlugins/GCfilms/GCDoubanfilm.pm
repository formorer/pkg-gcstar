package GCPlugins::GCfilms::GCDoubanfilm;

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

use GCPlugins::GCfilms::GCfilmsCommon;

{
    package GCPlugins::GCfilms::GCPluginDoubanfilm;

    use base qw(GCPlugins::GCfilms::GCfilmsPluginsBase);
    use XML::Simple;
    use Encode;
    use LWP::Simple qw($ua);

    sub parse
    {
        my ($self, $page) = @_;
		return if (($page =~ /^bad imdb/) & ($page =~ /^The/));
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
				foreach my $ItemMovie( @{$xml->{'entry'}}){
					$self->{itemIdx}++;
					$self->{itemsList}[ $self->{itemIdx} ]->{'url'}  = $ItemMovie->{'id'};
					$self->{itemsList}[ $self->{itemIdx} ]->{'title'}  = $ItemMovie->{'title'};
					foreach my $tmp_author (@{$ItemMovie->{'author'}}){
						{($self->{itemsList}[ $self->{itemIdx} ]->{'director'} ne '' ) and $self->{itemsList}[ $self->{itemIdx} ]->{'director'}.=',';}
						$self->{itemsList}[ $self->{itemIdx} ]->{'director'}.=$tmp_author->{'name'};
					}
					foreach my $check1(@{$ItemMovie->{'db:attribute'}}){
						my $db_attr1=$check1->{'name'};
						SWITCH1: {
							$db_attr1 eq 'country' and $self->{itemsList}[ $self->{itemIdx} ]->{'country'}=$check1->{'content'} ,last SWITCH1;
							$db_attr1 eq 'pubdate' and $self->{itemsList}[ $self->{itemIdx} ]->{'date'}=$check1->{'content'} ,last SWITCH1;
							;
						}
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
						$self->{itemsList}[ $self->{itemIdx} ]->{'director'}.=$tmp_author->{'name'};
						$self->{itemsList}[ $self->{itemIdx} ]->{'director'}.=',';
				}
				foreach my $check(@{$xml->{'db:attribute'}}){
					my $db_attr=$check->{'name'};
					SWITCH: {
						$db_attr eq 'country' and $self->{itemsList}[ $self->{itemIdx} ]->{country}=$check->{'content'} ,last;
						$db_attr eq 'pubdate' and $self->{itemsList}[ $self->{itemIdx} ]->{date}=$check->{'content'} ,last;
					}
				}
			}
		}
        else
        {
				$xml =$xs->XMLin($page,
					ForceArray => [ 'author' ],
					KeyAttr => {'db:tag'=>'name','link'=>'rel'});
			foreach my $tmp_author (@{$xml->{'author'}}){
				{($self->{itemsList}[ $self->{itemIdx} ]->{'director'} ne '' ) and $self->{itemsList}[ $self->{itemIdx} ]->{'director'}.=',';}
					$self->{curInfo}->{director}.=$tmp_author->{'name'};
			}
			$self->{curInfo}->{title}=$xml->{'title'};
			$self->{curInfo}->{original}=$xml->{'title'};
			$self->{curInfo}->{webPage}=$xml->{'link'}->{'alternate'}->{'href'};
			$self->{curInfo}->{synopsis}=$xml->{'summary'};			
			foreach my $check(@{$xml->{'db:attribute'}}){
				my $db_attr=$check->{'name'};
				SWITCH2: {
					$db_attr eq 'country' and $self->{curInfo}->{country}=$check->{'content'} ,last SWITCH2;
					$db_attr eq 'pubdate' and $self->{curInfo}->{date}=$check->{'content'} ,last SWITCH2;
					$db_attr eq 'cast' and { ($self->{curInfo}->{actors} ne '' ) and $self->{curInfo}->{actors}.=',' }, $self->{curInfo}->{actors}.=$check->{'content'} ,last SWITCH2;
					;
				}
			}
			
			my $tmp_image=$xml->{'link'}->{'image'}->{'href'};
			$tmp_image =~ s/spic/lpic/;
			$self->{curInfo}->{image}=$tmp_image;
		}
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            title    => 1,
			director => 1,
            date     => 1,
            country   => 1,
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
	    if ($self->{searchField} eq 'imdb')
        {
           return "http://api.douban.com/movie/subject/imdb/" .$word;
        }
        else
        {
           return "http://api.douban.com/movie/subjects?q=" .$word;
        }

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
            title    => 1,
            date     => 1,
            director => 1,
            country  => 1,
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
        return ['imdb', 'title'];
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
