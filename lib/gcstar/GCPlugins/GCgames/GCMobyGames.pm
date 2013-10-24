package GCPlugins::GCgames::GCMobyGames;

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
    package GCPlugins::GCgames::GCPluginMobyGames;

    use base 'GCPlugins::GCgames::GCgamesPluginsBase';
    use HTML::Entities;

    sub extractTips
    {
        my ($self, $html_ini) = @_;
        my $answer = "";
        my @tmpAnswer = ();
        my $html = $self->loadPage($html_ini, 0, 1);
        $html =~ s|<pre>||gi;
        $html =~ s|</pre>||gi;
        $html =~ s|<b>||gi;
        $html =~ s|</b>||gi;
        my $found = index($html,"class=\"sbL sbB sbT\">");
        if ( $found >= 0 )
        {
           $answer = substr($html, $found + length("class=\"sbL sbB sbT\">"),length($html)- $found -length("class=\"sbL sbB sbT\">") );
           $answer = substr($answer, 0, index($answer,"</td><td align="));

           $tmpAnswer[0] = decode_entities($answer);

           $found = index($html,"class=\"sbR sbL sbB\"><p>");
           if ( $found >= 0 )
           {
              my $html2 = substr($html, $found + length("class=\"sbR sbL sbB\"><p>"),length($html)- $found -length("class=\"sbR sbL sbB\"><p>") );
              $html2 = substr($html2, 0, index($html2,"</p>"));
              $html2 =~ s/<br>/\n/gi;
              $html2 =~ s|<p>|\n|gi;
              $html2 =~ s|</p>||gi;

              $tmpAnswer[1] = decode_entities($html2);
           }

        }

        return @tmpAnswer;
    }

    sub extractPlayer
    {
        my ($self, $html_ini, $word) = @_;
        my $html = 0;
        my $found = index($html_ini,$word);
        if ( $found >= 0 )
        {
           $html = substr($html_ini, $found + length($word),length($html_ini)- $found -length($word) );
           $html = substr($html,0, index($html,"</a>") );
           $html = reverse($html);
           $html = substr($html,0, index($html,">") );
           $html = reverse($html);
           $html =~ s/&nbsp;/ /g;
           $html =~ s/1 Player/1/;
        }
        return $html;
    }

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        $self->{inside}->{$tagname}++;
        if ($self->{parsingList})
        {
            if ( !$self->{insideSearchImage}
              && ($tagname eq 'a')
              && ( substr($attr->{href},0,6) eq '/game/' ) )
            {
                # Test if there is a platform name in it
                # (i.e. if we can find a second slash after game/ )
                if ($attr->{href} =~ m|/game/[^/]*/|)
                {
                    if ($self->{currentName})
                    {
                        $self->{itemIdx}++;
                        $self->{itemsList}[$self->{itemIdx}]->{url} = 'http://www.mobygames.com'.$attr->{href}.'';
                        $self->{itemsList}[$self->{itemIdx}]->{name} = $self->{currentName};
                        $self->{isPlatform} = 1;
                    }
                    else
                    {
                        # This is a game we want to add
                        $self->{isGame} = 1;
                        $self->{itemIdx}++;
                        $self->{itemsList}[$self->{itemIdx}]->{url} = 'http://www.mobygames.com'.$attr->{href}.'';
                        $self->{isName} = 1 ;
                    }
                }
                else
                {
                    # We will need the name later
                    $self->{isGameName} = 1;
                }
            }
            elsif ( ($tagname eq 'a') && ( substr($attr->{href},0,7) eq '/search' ) )
            {
                $self->{isGame} = 0;
            }
            elsif ($tagname eq 'div')
            {
                if ($attr->{class} eq 'searchResult')
                {
                    $self->{currentName} = '';
                }
                elsif ($attr->{class} eq 'searchImage')
                {
                    $self->{insideSearchImage} = 1;
                }
            }
            elsif ($tagname eq 'em')
            {
                $self->{isDate} = 1;
            }
        }
        elsif ($self->{parsingTips})
        {
            if (($tagname eq 'table') && ($attr->{summary} eq 'List of Tips and Tricks'))
            {
                $self->{isSectionTips} = 2;
            }
            elsif ( ($tagname eq 'b') && ($self->{isSectionTips} eq '2') )
            {
                $self->{isSectionTips} = 1;
            }
            elsif ( ($tagname eq 'tr') && (($attr->{class} eq 'mb1') || ($attr->{class} eq 'mb2')) )
            {
                $self->{isTip} = 1 if ($self->{isTip} eq 2);
                $self->{isCode} = 1 if ($self->{isCode} eq 2);
            }
            elsif ( ($tagname eq 'a') && ($self->{isTip} eq 1))
            {
                my @tips = $self->extractTips('http://www.mobygames.com'.$attr->{href}.'');
                if ($tips[0] =~ m/unlock/i)
                {
                   $Text::Wrap::columns = 80;
                   $tips[1] = Text::Wrap::wrap('', '', $tips[1]);
                   #$self->{tmpCheatLine} = [];
                   #push @{$self->{tmpCheatLine}}, @tips;
                   push @{$self->{curInfo}->{unlockable}}, \@tips;
                }
                else
                {
                   my $answer = $tips[0];
                   $answer .= "\n";
                   $answer .= $tips[1];
                   if ( ($self->{curInfo}->{secrets}) && ($answer ne "") )
                   {
                      $self->{curInfo}->{secrets} .= "\n\n\n"
                   }
                   $self->{curInfo}->{secrets} .= $answer;
                }
                $self->{isTip} = 2;
            }
            elsif ( ($tagname eq 'a') && ($self->{isCode} eq 1))
            {
                my @tips = $self->extractTips('http://www.mobygames.com'.$attr->{href}.'');
                @tips = reverse(@tips);
                $Text::Wrap::columns = 80;
                $tips[1] = Text::Wrap::wrap('', '', $tips[1]);
                #$self->{tmpCheatLine} = [];
                #push @{$self->{tmpCheatLine}}, @tips;
                push @{$self->{curInfo}->{code}}, \@tips;

                $self->{isCode} = 2;

            }
            elsif ($tagname eq 'br')
            {
                $self->{isTip} = 3;
                $self->{isCode} = 3;
                $self->{isSectionTips} = 0;
            }
            elsif ($tagname eq 'head')
            {
                $self->{isTip} = 0;
                $self->{isCode} = 0;
                $self->{isSectionTips} = 0;
            }

        }
        else
        {

            if ($tagname eq 'div')
            {
                    for ($attr->{id})
                    {
                        /^gameTitle$/ && ($self->{isName} = 1, last);
                        /^gamePlatform/ && ($self->{isPlatform} = 1, last);
                        #/^coreGameCover/ && ($self->{isBox} = 1, last);
                        /^coreGameRelease/ && ($self->{isEditor} = 1, last);
                    }
                    
                    if ($attr->{class} =~ m/scoreBoxBig/)
                    {
                        $self->{isRating} = 1;
                    }
                    
                    if ($self->{curInfo}->{genre})
                    {
                        $self->{isGenre} = 0;
                    }

                    $self->{isDescription} = 0;

            }
            elsif ( ($tagname eq 'a') && ($self->{isName}) )
            {
                    $self->{is} = 'name';
                    $self->{curInfo}->{exclusive} = 1;
                    $self->{isName} = 0;
            }
            elsif ( ($tagname eq 'a') && ($self->{isPlatform}) )
            {
                    $self->{is} = 'platform';
                    $self->{isPlatform} = 0;
            }
            elsif ( ($tagname eq 'a') && ($self->{isEditor}) )
            {
                    $self->{is} = 'editor';
                    $self->{isEditor} = 0;
            }
            elsif ( ($tagname eq 'a') && ($self->{isDeveloper}) )
            {
                    $self->{is} = 'developer';
                    $self->{isDeveloper} = 0;
            }
            elsif ( ($tagname eq 'a') && ($self->{isDate}) )
            {
                    $self->{is} = 'released';
                    $self->{isDate} = 0;
            }
            elsif ( ($tagname eq 'a') && ($self->{isGenre}) )
            {
                    $self->{is} = 'genre';
            }
            elsif ($tagname eq 'img')
            {
                if ($attr->{src} =~ m|covers/small|)
                {
                    $attr->{src} =~ s|/small/|/large/|
                        if $self->{bigPics};
                    $self->{curInfo}->{boxpic} = $attr->{src};
                    # From here we try to get back cover
                    my $covers = $self->loadPage($self->{rootUrl}.'/cover-art', 0, 1);
                    $covers =~ m|<img alt=".*?Back Cover".*?src="([^"]*)"|;
                    $self->{curInfo}->{backpic} = $1;
                    $self->{curInfo}->{backpic} =~ s|/small/|/large/|
                        if $self->{bigPics};                   
                }
            }
            elsif ($tagname eq 'html')
            {
                my $html = $self->loadPage($self->{curInfo}->{$self->{urlField}}.'/techinfo', 0, 1);
                my $player_offline = $self->extractPlayer($html, "Number&nbsp;of Players: Offline" );
                my $player_online = $self->extractPlayer($html, "Number&nbsp;of Players: Online" );
                my $player_total = $self->extractPlayer($html, "Number&nbsp;of Players Supported" );

                if ($player_total)
                {
                   $self->{curInfo}->{players} = $player_total;
                }
                else
                {
                    if ($player_offline)
                    {
                        $self->{curInfo}->{players} = 'Offline: '.$player_offline;
                    }
                    if ($player_online)
                    {
                        if ( $self->{curInfo}->{players} )
                        {
                            $self->{curInfo}->{players} .= '; Online: '.$player_online;
                        }
                        else
                        {
                            $self->{curInfo}->{players} = 'Online: '.$player_online;
                        }
                    }
                }

                $html = $self->loadPage($self->{curInfo}->{$self->{urlField}}.'/screenshots', 0, 1);
                my $screen = 1;
                while ($html =~ m|src="(/images/shots/[^"]*?)"|g)
                {
                    $self->{curInfo}->{'screenshot'.$screen} = 'http://www.mobygames.com' . $1;
                    $self->{curInfo}->{'screenshot'.$screen} =~ s|/images/shots/s/|/images/shots/l/|
                        if $self->{bigPics};
                    $screen++;
                    last if $screen > 2;
                }
            }
            elsif ( ($tagname eq 'br') && ($self->{isDescription}) )
            {
                $self->{curInfo}->{description} .= "\n";
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;
        $self->{inside}->{$tagname}--;
        if ($self->{parsingList} && ($tagname eq 'div'))
        {
            $self->{insideSearchImage} = 0;
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if ($self->{isName})
            {
                #$self->{itemsList}[$self->{itemIdx}]->{name} = $origtext;
                if ($origtext !~ /^Game:/)
                {
                    if (!$self->{currentName})
                    {
                        $self->{itemsList}[$self->{itemIdx}]->{name} = $origtext;
                    }
                    $self->{isName} = 0;
                }
            }
            elsif ($self->{isPlatform})
            {
                $self->{itemsList}[$self->{itemIdx}]->{platform} = $origtext;
                $self->{isPlatform} = 0;
            }
            elsif ($self->{isGameName})
            {
                $self->{currentName} = $origtext;
                $self->{isGameName} = 0;
            }
            elsif ($self->{isDate})
            {
                # <em> tags enclose both dates and the 'a.k.a.' text, so make sure we
                # ignore the aka ones
                if ($origtext !~ /^a\.k\.a\./)
                {          
                    $self->{itemsList}[$self->{itemIdx}]->{released} = $origtext;
                    if (! $self->{itemsList}[$self->{itemIdx}]->{platform})
                    {
                        $self->{previous} =~ s/[\s\(]*$//g;
                        $self->{itemsList}[$self->{itemIdx}]->{platform} = $self->{previous};
                    }
                }
                $self->{isDate} = 0;
            }
            $self->{previous} = $origtext;
        }
        elsif ($self->{parsingTips})
        {
            if ($self->{isSectionTips} eq 1)
            {
                if ($origtext =~ m/General Hints\/Tips/i)
                {
                   $self->{isTip} = 2;
                   $self->{isCode} = 0;
                }
                elsif ($origtext =~ m/Cheats\/Codes/i)
                {
                   $self->{isTip} = 0;
                   $self->{isCode} = 2;
                }
                $self->{isSectionTips} = 2;
            }
        }
        else
        {
            if ($self->{is})
            {
                $origtext =~ s/^\s*//;
                
                if ($self->{is} eq 'platform')
                {
                    $self->{curInfo}->{$self->{is}} = $origtext;
                    $self->{curInfo}->{platform} =~ s/DOS/PC/;
                    $self->{curInfo}->{platform} =~ s/Windows/PC/;
                }
                elsif ($self->{is} eq 'genre')
                {
                    push @{$self->{curInfo}->{genre}}, [ $origtext ];
                }
                else
                {
                    $self->{curInfo}->{$self->{is}} = $origtext;
                }

                $self->{is} = '';
            }
            elsif ($self->{isRating})
            {
                $self->{curInfo}->{ratingpress} = int($origtext/10+0.5);
                $self->{isRating} = 0;
            }
            elsif ($self->{isDescription})
            {
                    $self->{curInfo}->{description} .= $origtext;
            }
            elsif ($origtext eq 'Developed by')
            {
                $self->{isDeveloper} = 1
            }
            elsif ( ($origtext eq 'Also For') || (($origtext eq 'Platforms')))
            {
                $self->{curInfo}->{exclusive} = 0;
            }
            elsif ($origtext eq 'Released')
            {
                $self->{isDate} = 1
            }
            elsif ($origtext eq 'Genre')
            {
                $self->{isGenre} = 1
            }
            elsif ($origtext eq 'Description')
            {
                $self->{isDescription} = 1
            }
        }
    } 

    sub getTipsUrl
    {
        my $self = shift;
        my $url = $self->{curInfo}->{$self->{urlField}}.'/hints';
        $url =~ s/##MobyGames//;
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
            released => 1
        };

        $self->{isName} = 0;
        $self->{isGame} = 0;
        $self->{isGameName} = 0;
        $self->{isPlatform} = 0;
        $self->{isEditor} = 0;
        $self->{isDeveloper} = 0;
        $self->{isDate} = 0;
        $self->{isGenre} = 0;
        $self->{isDescription} = 0;
        $self->{isBox} = 0;
        $self->{isSectionTips} = 0;
        $self->{isTip} = 0;
        $self->{isCode} = 0;
        $self->{is} = '';

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        $self->{rootUrl} = $self->{loadedUrl};
        return $html;
    }
    
    sub getSearchUrl
    {
        my ($self, $word) = @_;
        return 'http://www.mobygames.com/search/quick?q='.$word.'&p=-1&search=Go&sFilter=1&sG=on';
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
		
        return $url if $url;
        return 'http://www.mobygames.com/';
    }

    sub getName
    {
        return 'MobyGames';
    }
    
    sub getAuthor
    {
        return 'TPF';
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
}

1;
