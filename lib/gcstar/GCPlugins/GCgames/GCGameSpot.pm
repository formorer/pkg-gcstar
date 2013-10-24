package GCPlugins::GCgames::GCGameSpot;

###################################################
#
#  Copyright 2005-2011 Christian Jodar
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
            if (($tagname eq 'h2') && ($attr->{class} eq 'module_title'))
            {
                $self->{isSection} = 1;
            }
            elsif (($tagname eq 'th') && ($attr->{scope} eq 'row') && ($attr->{class} eq 'code') && ($self->{section} ne ''))
            {
                $self->{isCheat} = 1;
            }
            elsif (($tagname eq 'td') && ($attr->{class} eq 'effect') && ($self->{section} ne ''))
            {
                $self->{isDesc} = 1;
            }
            elsif (($tagname eq 'h3') && ($attr->{class} eq 'cheatCodeTitle') && ($self->{section} eq 'Secrets'))
            {
                $self->{curInfo}->{secrets} .= "\n" if $self->{curInfo}->{secrets};
            }
            elsif ($tagname eq 'tpfdebuttpf')
            {
                $self->{section} = 'Secrets';
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'head'))
            {
                $self->{section} = '';
            }
            elsif ($tagname eq 'head')
            {
                $self->{urlTips} = '';
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
            elsif (($tagname eq 'h1') && ($attr->{class} eq 'productPageTitle'))
            {
                $self->{isName} = 1 if ! $self->{curInfo}->{name};
            }
            elsif (($tagname eq 'meta') && ($attr->{name} eq 'description'))
            {
                $self->{curInfo}->{description} = $attr->{content};
            }
            elsif (($tagname eq 'li') && ($attr->{class} =~ /activeFilter/))
            {
                $self->{curInfo}->{exclusive} = 0;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'reviewer'))
            {
                $self->{isRating} = 1;
            }
            elsif (($tagname eq 'a') && ($self->{isRating} eq 1))
            {
                $self->{isRating} = 2;
            }
            elsif (($tagname eq 'li') && ($attr->{class} eq 'moreStat play_info number_of_players'))
            {
                $self->{isPlayers} = 1;
            }
            elsif (($tagname eq 'p') && ($self->{isPlayers} eq 1))
            {
                $self->{isPlayers} = 2;
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
            elsif (($tagname eq 'a') && ($attr->{href} =~ /\/cheats\//) && ($attr->{class} eq 'navItemAction'))
            {
                $self->{urlTips} = $attr->{href};
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
                $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{itemsList}[$self->{itemIdx}]->{url} . 'tpfplatformtpf' . $self->{itemsList}[$self->{itemIdx}]->{platform};
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
            if (($self->{isSection} eq 1) && $self->{inside}->{h2})
            {
                $self->{section} = 'Codes' if $origtext =~ /Cheat Codes$/;
                $self->{section} = 'Unlockables' if $origtext =~ /Unlockables$/;
                $self->{section} = 'Secrets' if $origtext =~ /Secrets$/;
                $self->{section} = 'Secrets' if $origtext =~ /Easter Eggs$/;
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
                    if ($self->{section} eq 'Codes')
                    {
                        $self->{tmpCheatLine} = [];
                        push @{$self->{tmpCheatLine}}, $origtext;
                    }
                    else
                    {
                        $self->{tmpCheatLine} = [];
                        ${$self->{tmpCheatLine}}[1] = $origtext;
                    }
                    $self->{isCheat} = 0;
                }
                elsif ($self->{isDesc})
                {
                    if ($self->{section} eq 'Codes')
                    {
                        push @{$self->{tmpCheatLine}}, $origtext;
                        push @{$self->{curInfo}->{code}}, $self->{tmpCheatLine};
                        $self->{tmpCheatLine} = [];
                    }
                    else
                    {
                        ${$self->{tmpCheatLine}}[0] = $origtext;
                        push @{$self->{curInfo}->{unlockable}}, $self->{tmpCheatLine};
                        $self->{tmpCheatLine} = [];
                    }
                    $self->{isDesc} = 0;
                }
            }
            elsif ($self->{section} eq 'Secrets')
            {
                $origtext =~ s/^\s*//;
                $origtext =~ s/\s*$//;
                return if !$origtext;
                $self->{curInfo}->{secrets} .= "\n" if $self->{curInfo}->{secrets};
                $self->{curInfo}->{secrets} .= $origtext;
            }
        }
        else
        {
            if ($self->{isName})
            {
                $origtext =~ s/\n//g;
                $self->{curInfo}->{name} = $origtext;
                $self->{curInfo}->{platform} = $self->{url_plateforme};
                $self->{curInfo}->{exclusive} = 1;
                $self->{isName} = 0;
            }
            elsif ($self->{isRating} eq 2)
            {
                $self->{curInfo}->{ratingpress} = $origtext;
                $self->{isRating} = 0;
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
        return 'http://www.gamespot.com' .$self->{urlTips};
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
        $self->{isCheat} = 0;
        $self->{isDesc} = 0;
        $self->{isTip} = 0;
        $self->{isRating} = 0;
        $self->{section} = '';
        $self->{isSection} = 0;
        $self->{isDeveloper} = 0;
        $self->{isGenre} = 0;
        $self->{isEditor} = 0;
        $self->{isReleased} = 0;
        $self->{isPlayers} = 0;
        $self->{isBox} = 0;
        $self->{isExclu} = 0;
        $self->{url_plateforme} = '';
        $self->{urlTips} = "";
        $self->{SaveUrl} = "";

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingTips})
        {
            $html =~ s|<b>(.*?)</b>|$1|g;
            $html =~ s|<i>(.*?)</i>|$1|g;
## It takes too much time
#            $html =~ s|<li class="guideAct"><a href="(.+)">Go to Online Walkthrough|'<tpfdebuttpf>' . $self->RecupSolution($1) . '<tpffintpf>'|ge;
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
    
    sub RecupSolution
    {
        my ($self, $url) = @_;

        my $html = $self->loadPage($url);

        my $found = index($html,"<h2>");
        if ( $found >= 0 )
        {
            $html = substr($html, $found,length($html)- $found);
        }
        else
        {
            $found = index($html,"<span class=\"author\">");
            if ( $found >= 0 )
            {
                $html = substr($html, $found,length($html)- $found);
            }
        }

        $html = substr($html, 0, index($html, " rel=\"next\">"));

        $html =~ s|<a class="next" href="/gameguides.html"||ge;
        $html =~ s|<a class="next" href="(.+)"|$self->RecupSolution('http://www.gamespot.com'.$1)|ge;

        return $html;
    }

    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        #return 'http://www.gamespot.com/search.html?qs='.$word.'&sub=g&stype=11&type=11';
        return 'http://www.gamespot.com/pages/search/solr_search_ajax.php?q='.$word.'&type=game&offset=0&tags_only=false&sort=false';
        #return 'http://www.gamespot.com/search.html?qs=' .$word. '&tag=masthead%3Bsearch';
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
        my $found = index($url,"tpfplatformtpf");
        if ( $found >= 0 )
        {
            $self->{url_plateforme} = substr($url, $found +length('tpfplatformtpf'),length($url)- $found -length('tpfplatformtpf'));
            $url = substr($url, 0,$found);
        }

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
