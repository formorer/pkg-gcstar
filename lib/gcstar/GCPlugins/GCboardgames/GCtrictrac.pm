package GCPlugins::GCboardgames::GCtrictrac;

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

use GCPlugins::GCboardgames::GCboardgamesCommon;

{
    package GCPlugins::GCboardgames::GCPlugintrictrac;

    use base qw(GCPlugins::GCboardgames::GCboardgamesPluginsBase);
 
    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingEnded})
        {
            return;
        }
        

        if ($self->{parsingList})
        {
            # Parse the search results here

            # Check if we are currently parsing an item page, not a search results page (ie - exact match has taken us straight to the page)
            # Do this by checking if there is a heading on the page
            if (($tagname eq "font") && ($attr->{style} =~ /FONT-SIZE: 20px/))
            {
                # Stop parsing results, switch to item parsing
                $self->{parsingEnded} = 1;
                $self->{itemIdx} = 0;
                $self->{itemsList}[0]->{url} = $self->{loadedUrl};
            }

            # Quite easy to parse the search results page since all the information we need (url, title, year) is contained within the <a>
            # tag for the image of each search result

            # TODO - check how search results look when they do not have an image??

            # Check if tag is an <a>, the url referenced is valid (not "#"), and the onmouseover text looks right
            if (($tagname eq "a") && ($attr->{href} ne "#") && ($attr->{onmouseover} =~ /^(return overlib)/))
            {

                # Add to search results
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} =  $attr->{href};

                my $mouseoverText = $attr->{onmouseover};

                # Parse some regular expressions to find the name and release date
                if ($mouseoverText =~ /<b>(.+)<\/b>/)
                {
                   $self->{itemsList}[$self->{itemIdx}]->{name} = $1;
                }
                if ($mouseoverText =~ /<\/b> \((\d+)\)/)
                {
                   $self->{itemsList}[$self->{itemIdx}]->{released} = $1;
                }
            }
        }
        else
        {
            # Parse the items page here. Basically we do this by seaching for tags which match certain criteria, then preparing to grab
            # the text inside these tags

            if (($tagname eq "font") && ($attr->{style} =~ /FONT-SIZE: 20px/))
            {
                $self->{insideName} = 1;
            }
            elsif (($tagname eq "font") && ($attr->{style} =~ /FONT-SIZE: 12px/))
            {
                if ($self->{nextIsPlayers})
                {
                    $self->{insidePlayers} = 1;
                    $self->{nextIsPlayers} = 0;
                }
                if ($self->{nextIsAges})
                {
                    $self->{insideAges} = 1;
                    $self->{nextIsAges} = 0;
                }
                if ($self->{nextIsPlayingTime})
                {
                    $self->{insidePlayingTime} = 1;
                    $self->{nextIsPlayingTime} = 0;
                }
                
            }
            elsif (($tagname eq "td") && ($attr->{height} eq "250") && ($attr->{width} eq "250")) 
            {
                $self->{insideImage} = 1;
            } 
            elsif ($tagname eq "img")
            {
                if ($self->{insideImage})
                {
                    $self->{curInfo}->{boxpic} = "http://trictrac.net".$attr->{src} if ! $self->{curInfo}->{boxpic};
                    $self->{insideImage} = 0;
                }
            }
            elsif ($tagname eq "a")
            {
                if ($self->{nextIsYear})
                {
                    $self->{insideYear} = 1;
                    $self->{nextIsYear} = 0;
                }
                if ($self->{insideDesignerRow})
                {
                    $self->{insideDesigner} = 1;
                }
                if ($self->{insideIllustratorRow})
                {
                    $self->{insideIllustrator} = 1;
                }
                if ($self->{nextIsPublishers})
                {
                    $self->{insidePublishers} = 1;
                    $self->{nextIsPublishers} = 0;
                }
                if ($self->{insideMechanicRow})
                {
                    $self->{insideMechanic} = 1;
                }
                if ($self->{insideCategoryRow})
                {
                    $self->{insideCategory} = 1;
                }
                
            }
            elsif ($tagname eq "b")
            {
                if ($self->{insideExpansionList})
                {
                    $self->{insideExpansion} = 1;
                }
            }
            elsif (($tagname eq "p") && ( $attr->{style} =~ /TEXT-ALIGN: justify/))
            {
                $self->{insideDescription} = 1;
            }
            if ($self->{insideDescription})
            {
                if ($tagname eq "br")
                {
                    # neatens up the description a little by starting new line on br tags
                    $self->{curInfo}->{description} .= "\n";
                }
                elsif ($tagname eq "li")
                {
                    # basic formatting of lists
                    $self->{curInfo}->{description} .= " - ";
                }
            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;	
        $self->{inside}->{$tagname}--;
        if ($tagname eq "tr")
        {
            if ($self->{insideDesignerRow})
            {
                # Use regex to strip final , off end of line
                $self->{curInfo}->{designedby} =~ s/(, )$//;
                $self->{insideDesignerRow} = 0;
            }
            if ($self->{insideIllustratorRow})
            {
                # Use regex to strip final , off end of line
                $self->{curInfo}->{illustratedby} =~ s/(, )$//;
                $self->{insideIllustratorRow} = 0;
            }
            if ($self->{insideMechanicRow})
            {
                $self->{insideMechanicRow} = 0;
            }
            if ($self->{insideCategoryRow})
            {
                $self->{insideCategoryRow} = 0;
            }
        }
        elsif ($tagname eq "table")
        {            
	        if ($self->{insideExpansionList})
	        {
	            $self->{insideExpansionList} = 0;
	        }
        }
        elsif ($tagname eq "b")
        {
            if ($self->{insideExpands})
            {
                $self->{curInfo}->{expansionfor} =~ s/"//g;
                $self->{insideExpands} = 0;
            }
        }
        elsif (($tagname eq "td") && ($self->{insideDescription}))
        {
            $self->{insideDescription} = 0;
            # remove spaces from start and end of description
            $self->{curInfo}->{description} =~ s/^\s+//;
            $self->{curInfo}->{description} =~ s/\s+$//;
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if (length($origtext) < 2);
        
        $origtext =~ s/&#34;/"/g;
        $origtext =~ s/&#179;/3/g;
        $origtext =~ s/\n//g;
        $origtext =~ s/^\s{2,//;
        #French accents substitution
        $origtext =~ s/&agrave;/à/;
        $origtext =~ s/&eacute;/é/;
        
        return if ($self->{parsingEnded});
        
        if ($self->{parsingList})
        {
    
        }
        else
        {
            # fetching information from page 
            if ($origtext =~ /^Nom VO/)
            {
                $self->{curInfo}->{original} = $origtext;
                $self->{curInfo}->{original} =~ s/Nom VO : //;
            }
            if ($self->{insideName})
            {
                $self->{curInfo}->{name} = $origtext;
                $self->{insideName} = 0;
            }
            elsif ($self->{insideYear})
            {
                $self->{curInfo}->{released} = $origtext;
                $self->{curInfo}->{released} =~ s/([^0-9])//g;
                $self->{insideYear} = 0;
            }
            elsif ($self->{insideDesigner})
            {
                # Append text (and trailing ,) to existing designer field
                $self->{curInfo}->{designedby} .= $origtext.", ";
                $self->{insideDesigner} = 0;
            }
            elsif ($self->{insideIllustrator})
            {
                # Append text (and trailing ,) to existing designer field
                $self->{curInfo}->{illustratedby} .= $origtext.", ";
                $self->{insideIllustrator} = 0;
            }
            elsif ($self->{insidePublishers})
            {
                $self->{curInfo}->{publishedby} = $origtext;
                $self->{insidePublishers} = 0;
            }
            elsif ($self->{insidePlayers})
            {
                $self->{curInfo}->{players} = $origtext;
                $self->{insidePlayers} = 0;
            }
            elsif ($self->{insideAges})
            {
                $self->{curInfo}->{suggestedage} = $origtext;
                $self->{insideAges} = 0;
            }
            elsif ($self->{insidePlayingTime})
            {
                $self->{curInfo}->{playingtime} = $origtext;
                $self->{insidePlayingTime} = 0;
            }            
            elsif ($self->{insideExpands})
            {
                $self->{curInfo}->{expansionfor} .= $origtext;

            }
            elsif ($self->{insideExpansion})
            {
                $self->{curInfo}->{expandedby} .= $self->capWord($origtext).',';
                $self->{insideExpansion} = 0;
            }
            elsif ($self->{insideDescription})
            {
                $self->{curInfo}->{description} .= $origtext;
            }
            elsif ($self->{insideMechanic})
            {
                $self->{curInfo}->{mechanics} .= $self->capWord($origtext).',';
                $self->{insideMechanic} = 0;
            }
            elsif ($self->{insideCategory})
            {
                $self->{curInfo}->{category} .= $self->capWord($origtext).',';
                $self->{insideCategory} = 0;
            }
            

            # Pre-detection based on text (not tags) for various fields
            # that have no specific id in tags  
            if ($origtext =~ /^Ann\xe9e/)
            {
                $self->{nextIsYear} = 1;
            }
            if ($origtext =~ /^Auteur/)
            {
                $self->{insideDesignerRow} = 1;
            }
            if ($origtext =~ /^Illustrateur/)
            {
                $self->{insideIllustratorRow} = 1;
            }
            if ($origtext =~ /^Editeur/)
            {
                $self->{nextIsPublishers} = 1;
            }
            if ($origtext =~ /^Joueurs/)
            {
                $self->{nextIsPlayers} = 1;
            }
            if ($origtext =~ /^Age/)
            {
                $self->{nextIsAges} = 1;
            }            
            if ($origtext =~ /^Dur/)
            {
                $self->{nextIsPlayingTime} = 1;
            }
            if ($origtext =~ /^Ceci est une extension pour/)
            {
                $self->{insideExpands} = 1;
            }
            if ($origtext =~ /canisme\(s\)/)
            {
                $self->{insideMechanicRow} = 1;
            }
            if ($origtext =~ /Th.{1,8}me\(s\)/)
            {
                $self->{insideCategoryRow} = 1;
            }
            if ($origtext =~ /^Les extensions/)
            {
                $self->{insideExpansionList} = 1;
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
            name => 1,
            released => 1,
        };

        $self->{isBoardgame} = 0;
        $self->{curName} = undef;
        $self->{curUrl} = undef;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;
        
        $self->{parsingEnded} = 0;
        
        $html =~ s/"&#34;/'"/g;
        $html =~ s/&#34;"/"'/g;
        $html =~ s|</a></b><br>|</a><br>|;

        $html =~ s|\x{92}|'|gi;
        $html =~ s|&#146;|'|gi;
        $html =~ s|&#149;|*|gi;
        $html =~ s|&#133;|...|gi;
        $html =~ s|\x{85}|...|gi;
        $html =~ s|\x{8C}|OE|gi;
        $html =~ s|\x{9C}|oe|gi;

        return $html;
    }

    sub getSearchUrl
    {
	my ($self, $word) = @_;
	  
        # Url returned below is the for the search page, where $word is replaced by the search  
	return "http://trictrac.net/index.php3?id=jeux&rub=ludotheque&inf=cat&choix=$word";
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
		
        return $url if $url =~ /^http:/;
        if ($url =~ /^\//)
        {
            return "http://trictrac.net".$url;
        }
        else
        {
            return "http://trictrac.net/".$url;
        }
    }

    sub getName
    {
        return "Tric Trac";
    }
    
    sub getAuthor
    {
        return 'Florent';
    }
    
    sub getLang
    {
        return 'FR';
    }
    
    
}

1;
