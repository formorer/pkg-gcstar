package GCPlugins::GCbooks::GCDoubanbook;

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

use GCPlugins::GCbooks::GCbooksCommon;

{
    package GCPlugins::GCbooks::GCPluginDoubanbook;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
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
				foreach my $ItemBook ( @{$xml->{'entry'}}){
					$self->{itemIdx}++;
					$self->{itemsList}[ $self->{itemIdx} ]->{'url'}  = $ItemBook->{'id'};
					$self->{itemsList}[ $self->{itemIdx} ]->{'title'}  = $ItemBook->{'title'};
					foreach my $tmp_author (@{$ItemBook->{'author'}}){
						{($self->{itemsList}[ $self->{itemIdx} ]->{'authors'} ne '' ) and $self->{itemsList}[ $self->{itemIdx} ]->{'authors'}.=',';}
						$self->{itemsList}[ $self->{itemIdx} ]->{'authors'}.=$tmp_author->{'name'};
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
						$self->{itemsList}[ $self->{itemIdx} ]->{'authors'}.=$tmp_author->{'name'};
						$self->{itemsList}[ $self->{itemIdx} ]->{'authors'}.=',';
				}
			}
        }
        else
        {
				$xml =$xs->XMLin($page,
					ForceArray => [ 'author' ],
					KeyAttr => {'db:tag'=>'name','link'=>'rel'});
			foreach my $tmp_author (@{$xml->{'author'}}){
					$self->{curInfo}->{authors}.=$tmp_author->{'name'};
					$self->{curInfo}->{authors}.=',';
			}
			$self->{curInfo}->{title}=$xml->{'title'};
			$self->{curInfo}->{description}=$xml->{'summary'};
			$self->{curInfo}->{web}=$xml->{'link'}->{'alternate'}->{'href'};
			foreach my $check(@{$xml->{'db:attribute'}}){
				my $db_attr=$check->{'name'};
				SWITCH: {
					$db_attr eq 'publisher' and $self->{curInfo}->{publisher}=$check->{'content'} ,last;
					$db_attr eq 'pubdate' and $self->{curInfo}->{publication}=$check->{'content'} ,last;
					$db_attr eq 'pages' and $self->{curInfo}->{pages}=$check->{'content'} ,last;
					$db_attr eq 'isbn13' and $self->{curInfo}->{isbn}=$check->{'content'} ,last;
					$db_attr eq 'binding' and $self->{curInfo}->{format}=$check->{'content'} ,last;					
					$db_attr eq 'translator' and { ($self->{curInfo}->{translator} ne '' ) and $self->{curInfo}->{translator}.=',' }, $self->{curInfo}->{translator}.=$check->{'content'} ,last;
					$db_attr eq 'author-intro' and $self->{curInfo}->{description}.="\n\n".$check->{'content'},last;
					;
				}
			}
			
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
            authors => 1,
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
	    if ($self->{searchField} eq 'isbn')
        {
           return "http://api.douban.com/book/subject/isbn/" .$word;
        }
        else
        {
           return "http://api.douban.com/book/subjects?q=" .$word;
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
                title => 1,
                authors => 1,
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
