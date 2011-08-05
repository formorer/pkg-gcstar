package GCPlugins::GCgames::GCGameSpot;

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
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###################################################

use strict;
use utf8;

use GCPlugins::GCgames::GCgamesCommon;

{
    package GCPlugins::GCgames::GCPluginGameSpot;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';
    use Text::Wrap;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;
        if ($self->{parsingList})
        {
            if ($tagname eq 'div')
            {
                $self->{isGame} = 1
                    if $attr->{class} =~ /result_title/;
            }
            elsif ($tagname eq 'tpfdatetpf')
            {
                $self->{isDate} = 1;
            }
            elsif (($tagname eq 'a') && ($self->{isGame}))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                $self->{isName} = 1;
            }
        }
        elsif ($self->{parsingTips})
        {
            if ($tagname eq 'div')
            {
                if ($attr->{class} eq 'module')
                {
                    $self->{section} = '';
                    $self->{isSection} = 1;
                }
                if ($attr->{class} eq 'quick_links')
                {
                    # To be sure we don't get extra data
                    $self->{section} = '';
                    $self->{isSection} = 0;
                }
            }
            elsif ($tagname eq 'td')
            {
                $self->{isCheat} = 1
                    if $attr->{class} eq 'cheat';
                $self->{isDesc} = 1
                    if $attr->{class} eq '';
            }
        }
        else
        {
            if ($tagname eq 'img')
            {
                $self->{curInfo}->{boxpic} = ' '
                    if $attr->{src} =~ /no_preview/;
                if ((! $self->{curInfo}->{boxpic}) && ($attr->{src} =~ /[^xo]boxs[^c]/))
                {
                   $self->{curInfo}->{boxpic} = $attr->{src};
                }
                if ($attr->{src} =~ /thumb/)
                {
                    my $pic = $attr->{src};
                    $pic =~ s/thumb00([0-9])/screen00$1/;
                    if ($1 && ($1 <= 2))
                    {
                        $self->{curInfo}->{'screenshot'.$1} = $pic
                            if ! $self->{curInfo}->{'screenshot'.$1};
                    }
                }
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'boxshot'))
            {
                $self->{isBox} = 1;
            }
            elsif (($tagname eq 'a') && ($self->{isBox} eq 1))
            {
                my $html = $self->loadPage($self->getItemUrl($attr->{href}), 0, 1);
                my $found = index($html,"id=\"main_image\" src=\"");
                if ( $found >= 0 )
                {
                   $html = substr($html, $found +length('id="main_image" src="'),length($html)- $found -length('id="main_image" src="'));

                   my @array = split(/"/,$html);
                   #"
                   if ($self->{bigPics})
                   {
                      $self->{curInfo}->{boxpic} = $array[0];
                   }
                   $self->{curInfo}->{backpic} = $array[0];
                   $self->{curInfo}->{backpic} =~ s/_front/_back/;
               }
               $self->{isBox} = 0;
            }
            elsif ($tagname eq 'h2')
            {
                $self->{isName} = 1 if ! $self->{curInfo}->{name};
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'label'))
            {
                $self->{isInfo} = 1;
            }
            elsif (($tagname eq 'p') && ($self->{isPlayers} eq 1))
            {
                $self->{isPlayers} = 2;
            }
            elsif ($tagname eq 'p')
            {
                $self->{isDesc} = 1 if $attr->{class} eq 'review deck';
            }
            elsif ($tagname eq 'div')
            {
                $self->{isDesc} = 1 if $attr->{class} eq 'f12 dots pb5 mb5';
            }
            elsif ($tagname eq 'title')
            {
                $self->{isPlatform} = 1;
            }
            elsif (($tagname eq 'li') && ($attr->{class} eq 'publisher'))
            {
                $self->{isEditor} = 1;
            }
            elsif (($tagname eq 'a') && ($self->{isEditor} eq 1))
            {
                $self->{isEditor} = 2;
            }
            elsif (($tagname eq 'li') && ($attr->{class} eq 'developer'))
            {
                $self->{isDeveloper} = 1;
            }
            elsif (($tagname eq 'a') && ($self->{isDeveloper} eq 1))
            {
                $self->{isDeveloper} = 2;
            }
            elsif (($tagname eq 'li') && ($attr->{class} eq 'genre'))
            {
                $self->{isGenre} = 1;
            }
            elsif (($tagname eq 'a') && ($self->{isGenre}))
            {
                $self->{curInfo}->{genre} = $attr->{title};
                $self->{isGenre} = 0;
            }
            elsif (($tagname eq 'li') && ($attr->{class} eq 'date'))
            {
                $self->{isReleased} = 1;
            }
            elsif (($tagname eq 'a') && ($self->{isReleased} eq 1))
            {
                $self->{isReleased} = 2;
            }
        }
    }

    sub end
    {
		my ($self, $tagname) = @_;
		
        $self->{inside}->{$tagname}--;
        if ($self->{parsingList})
        {
            $self->{isGame} = 0
                if ($tagname eq 'div');
        }
        elsif ($self->{parsingTips})
        {
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if ($self->{isName})
            {
                $origtext =~ /^(.*?)\s*\((.*?)\)\s*$/;
                $self->{itemsList}[$self->{itemIdx}]->{name} = $1;
                $self->{itemsList}[$self->{itemIdx}]->{platform} = $2;
                $self->{isName} = 0;
            }
            elsif ($self->{isDate})
            {
                $origtext =~ /^\s*Release Date:\s*(.*?)\s*$/ms;
                $self->{itemsList}[$self->{itemIdx}]->{released} = $1;
                $self->{isDate} = 0;
            }
        }
        elsif ($self->{parsingTips})
        {
            if (($self->{isSection}) && $self->{inside}->{h2})
            {
                $self->{section} = 'Codes' if $origtext =~ /Cheat Codes$/;    
                $self->{section} = 'Secrets' if $origtext =~ /Secrets$/;    
                $self->{section} = 'Unlockables' if $origtext =~ /Unlockables$/;    
                $self->{curInfo}->{code} = [] if $self->{section} eq 'Codes';
                $self->{curInfo}->{unlockable} = [] if $self->{section} eq 'Unlockables';
                $self->{isSection} = 0;
            }
            elsif (($self->{section} eq 'Codes') || ($self->{section} eq 'Unlockables'))
            {
                $origtext =~ s/^\s*//;
                $origtext =~ s/\s*$//;
                $Text::Wrap::columns = 80;
                $origtext = Text::Wrap::wrap('', '', $origtext);
                
                if ($self->{isCheat})
                {
                    $self->{tmpCheatLine} = [];
                    push @{$self->{tmpCheatLine}}, $origtext;
                    $self->{isCheat} = 0;
                }
                elsif ($self->{isDesc})
                {
                    push @{$self->{tmpCheatLine}}, $origtext;
                    if ($self->{section} eq 'Codes')
                    {
                        push @{$self->{curInfo}->{code}}, $self->{tmpCheatLine};
                    }
                    else
                    {
                        push @{$self->{curInfo}->{unlockable}}, $self->{tmpCheatLine};
                    }
                    $self->{isDesc} = 0;
                }
            }
            elsif ($self->{section} eq 'Secrets')
            {
                $origtext =~ s/^\s*//;
                $origtext =~ s/\s*$//;
                return if !$origtext;
                $self->{curInfo}->{secrets} .= "\n\n" if $self->{curInfo}->{secrets};
                $self->{curInfo}->{secrets} .= $origtext;
            }
        }
        else
        {
            if ($self->{isName})
            {
                $origtext =~ s/\n//g;
                $self->{curInfo}->{name} = $origtext;
                $self->{isName} = 0;
            }
            elsif ($self->{isDesc})
            {
                $origtext =~ s/^\s*//;
                $origtext =~ s/\s*$//;
                $self->{curInfo}->{description} = $origtext;
                $self->{isDesc} = 0;
            }
            elsif ($self->{isInfo})
            {
                $self->{isPlayers} = 1 if $origtext =~ /Number of Players:\s*/;
                $self->{isInfo} = 0;
            }
            elsif ($self->{isPlatform})
            {
                $origtext =~ /^.*?for\s*(.*?)\s*-/;
                $self->{curInfo}->{platform} = $1;
                $self->{isPlatform} = 0;
            }
            else
            {
                $origtext =~ s/^\s*//;
                $origtext =~ s/\s*$//;
                return if !$origtext;
                if ($self->{isReleased} eq 2)
                {
                    $origtext =~ s/ .$//;
                    $self->{curInfo}->{released} = $origtext;
                    $self->{isReleased} = 0;
                }
                elsif ($self->{isEditor} eq 2)
                {
                    $self->{curInfo}->{editor} = $origtext;
                    $self->{isEditor} = 0;
                }
                elsif ($self->{isDeveloper} eq 2)
                {
                    $self->{curInfo}->{developer} = $origtext;
                    $self->{isDeveloper} = 0;
                }
                elsif ($self->{isPlayers} eq 2)
                {
                    $origtext =~ s/(Players?)?\s*\(.*?$//;
                    $self->{curInfo}->{players} = $origtext;
                    $self->{isPlayers} = 0;
                }
            }
        }
    } 

    sub getTipsUrl
    {
        my $self = shift;
        
        my $url = $self->{curInfo}->{$self->{urlField}};
        $url =~ s/index\.html/hints.html/;
        return $url;
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        bless ($self, $class);

        $self->{hasField} = {
            name => 1,
            platform => 1,
            released => 1,
        };

        $self->{isName} = 0;
        $self->{isGame} = 0;
        $self->{isDate} = 0;
        $self->{isDesc} = 0;
        $self->{isInfo} = 0;
        $self->{isCheat} = 0;
        $self->{isDesc} = 0;
        $self->{section} = '';
        $self->{isSection} = 0;
        $self->{isDeveloper} = 0;
        $self->{isGenre} = 0;
        $self->{isEditor} = 0;
        $self->{isReleased} = 0;
        $self->{isPlayers} = 0;
        $self->{isBox} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingTips})
        {
            $html =~ s|<b>(.*?)</b>|$1|g;
        }
        elsif ($self->{parsingList})
        {
            $html =~ s|Release Date|<tpfdatetpf>Release Date|g;
        }
        else
        {
            my $found = index($html,"Similar Games");
            if ( $found >= 0 )
            {
               $html = substr($html, 0, $found);
            }
        }

        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        #return 'http://www.gamespot.com/search.html?qs='.$word.'&sub=g&stype=11&type=11';
        return 'http://www.gamespot.com/pages/search/solr_search_ajax.php?q='.$word.'&type=game&offset=0&tags_only=false&sort=false';
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
        return 'http://www.gamespot.com' . $url
            if $url !~ /gamespot\.com/;
        return $url if $url;
        return 'http://www.gamespot.com';
    }

    sub getName
    {
        return 'GameSpot';
    }
    
    sub getAuthor
    {
        return 'Tian';
    }
    
    sub getLang
    {
        return 'EN';
    }

    sub getCharset
    {
        my $self = shift;
    
        return "ISO-8859-1";
    }
    sub isPreferred
    {
        return 1;
    }
}

1;
