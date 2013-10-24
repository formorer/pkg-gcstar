package GCPlugins::GCboardgames::GCReservoirJeux;

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
    package GCPlugins::GCboardgames::GCPluginReservoirJeux;

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
            if (($tagname eq "h3") && ($attr->{class} =~ /^rusearch_result/))
            {
                $self->{itemIdx}++;
                $self->{isBoardgame} = 1;
                $self->{insideName} = 1;
            }
            if ($self->{isBoardgame})
            {
                if (($tagname eq "a") && ($attr->{href} ne "#") && ($attr->{class} =~ /^lien_item/))
                {
                    $self->{itemsList}[$self->{itemIdx}]->{url} =  $attr->{href};
                    $self->{isBoardgame} = 0;
                }
            }
        }
        else
        {
            # Parse the items page here. Basically we do this by seaching for tags which match certain criteria, then preparing to grab
            # the text inside these tags

            if (($tagname eq "h1"))
            {
                $self->{insideName} = 1;
            }
            elsif (($tagname eq "div"))
            {
                if ($attr->{id} eq "fiche_technique_image")
                {
                    $self->{insideImage} = 1;
                }
                elsif ($attr->{id} eq "bloc_centre_extensions")
                {
                    $self->{insideExpansionList} = 1;
                }
                elsif ($attr->{id} eq "bloc_centre_extensions_bottom")
                {
                    $self->{insideExpansionList} = 0;
                }
                elsif ($attr->{class} eq "fiche_technique_sep")
                {
                    $self->{insideCategoryRow} = 0;
                    $self->{insideMechanicRow} = 0;
                }
                
            }
            elsif ($tagname eq "img")
            {
                if ($self->{insideImage})
                {
                    $self->{curInfo}->{boxpic} = "http://www.reservoir-jeux.com".$attr->{src} if ! $self->{curInfo}->{boxpic};
                    $self->{insideImage} = 0;
                }
                if ($self->{insideExpansionList}) 
                {
                    $self->{curInfo}->{expandedby} .= $attr->{alt}.','
                }
            }
            elsif ($tagname eq "a")
            {
                if ($attr->{class} eq "lien_item")
                {
                    if ($self->{nextIsExpands})
                    {
                        $self->{insideExpands} = 1;
                        $self->{nextIsExpands} = 0;
                    }
                        
                    if ($attr->{href} =~ /type=editeur/)
                    {
                        $self->{insidePublisher} = 1;
                    }
                    elsif ($attr->{href} =~ /type=auteur/)
                    {
                        $self->{insideDesigner} = 1;
                    }
                    elsif ($attr->{href} =~ /type=illustrateur/)
                    {
                        $self->{insideIllustrator} = 1;
                    }
                    elsif ($attr->{href} =~ /tag_id=/)
                    {
                        if ($self->{insideMechanicRow})
                        {
                            $self->{insideMechanic} = 1;
                        }
                        elsif ($self->{insideCategoryRow})
                        {
                            $self->{insideCategory} = 1;
                        }
                    }
                    elsif ($attr->{href} =~ /type=illustrateur/)
                    {
                        $self->{insideIllustrator} = 1;
                    }
                    
                    
                }
            }
            elsif (($tagname eq "span") && ($attr->{class} eq "prod_description"))
            {
                $self->{insideDescription} = 1;
            }

            if ($tagname eq "br")
            {
                if($self->{insideDesignerRow})
                {
                    $self->{curInfo}->{designedby} =~ s/\s\x2d\s$//g;
                    $self->{insideDesignerRow} = 0;
                }
                if($self->{insideIllustratorRow})
                {
                    $self->{curInfo}->{illustratedby} =~ s/\s\x2d\s$//g;
                    $self->{insideIllustratorRow} = 0;
                }
            }

            if ($self->{insideDescription})
            {
                if (($tagname eq "br") || ($tagname eq "p")) 
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

        if ($self->{insideTechnicalDetails} && $tagname eq "div")
        {
            $self->{insideTechnicalDetails} = 0;
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
        $origtext =~ s/&Agrave;/À/;
        $origtext =~ s/&eacute;/é/;

        return if ($self->{parsingEnded});
        
        if ($self->{parsingList})
        {
            if ($self->{isBoardgame} && $self->{insideName})
            {
                $self->{itemsList}[$self->{itemIdx}]->{name} = $origtext;
                $self->{insideName} = 0;
            }
    
        }
        else
        {   
            # Parse the text items page here.

            if ($self->{insideName})
            {
                $self->{curInfo}->{name} = $origtext;
                $self->{curInfo}->{name} =~ s/^\s+//;
                $self->{curInfo}->{name} =~ s/\s+\Z//;
                $self->{insideName} = 0;
            }
            if ($self->{inside}->{h2})
            {
                if ($origtext =~ /^Fiche technique/)
                {
                    $self->{insideTechnicalDetails} = 1;
                }
                elsif ($origtext =~ /^M\xe9canismes/)
                {
                    $self->{insideMechanicRow} = 1;
                }
                elsif ($origtext =~/^Th\xe8mes/)
                {
                    $self->{insideCategoryRow} = 1;
                    
                }
            }
            if ($self->{insideTechnicalDetails})
            {
                if ($origtext =~ /^Date de sortie/)
                {
                    $self->{curInfo}->{released} = $origtext;
                    $self->{curInfo}->{released} =~ s/Date de sortie : //g
                }
                elsif( $origtext =~ /Dur\xe9e : /)
                {
                    $self->{curInfo}->{playingtime} = $origtext;
                    $self->{curInfo}->{playingtime} =~ s/\s*Dur\xe9e : //g;
                }
                elsif($origtext =~ /\xc0 partir de\s[0-9]*\sans/)
                {
                    $self->{curInfo}->{suggestedage} = $origtext;
                    $self->{curInfo}->{suggestedage} =~ s/^\s*//g;
                }
                elsif ($origtext =~ /De [0-9]* \xe0 [0-9]* joueurs/)
                {
                    $self->{curInfo}->{players} = $origtext;
                    $self->{curInfo}->{players} =~ s/^\s*De //g;
                    $self->{curInfo}->{players} =~ s/ joueurs//g;
                }
            }
            if ($self->{insideDesigner})
            {
                # Append text (and trailing ,) to existing designer field
                $self->{curInfo}->{designedby} .= $origtext." - ";
                $self->{insideDesigner} = 0;
            }
            if ($self->{insideIllustrator})
            {
                # Append text (and trailing ,) to existing illustrator field
                $self->{curInfo}->{illustratedby} .= $origtext." - ";
                $self->{insideIllustrator} = 0;
            }
            if ($self->{insidePublisher})
            {
                $self->{curInfo}->{publishedby} = $origtext;
                $self->{insidePublisher} = 0;
            }
            if ($self->{insideExpands})
            {
                $self->{curInfo}->{expansionfor} = $origtext;
                $self->{insideExpands} = 0;
            }
            if ($self->{insideMechanic})
            {
                $self->{curInfo}->{mechanics} .= $self->capWord($origtext).',';
                $self->{insideMechanic} = 0;
            }
            if ($self->{insideCategory})
            {
                $self->{curInfo}->{category} .= $self->capWord($origtext).',';
                $self->{insideCategory} = 0;
            }
            
            
            if ($origtext =~ /^\s*Auteur(s)? : /)
            {
                $self->{insideDesignerRow} = 1;
            }
            if ($origtext =~ /^\s*Illustrateur(s)? : /)
            {
                $self->{insideIllustratorRow} = 1;
            }
            if ($origtext =~ /^Ce produit est une extension de :/)
            {
                $self->{nextIsExpands} = 1;
            }
            if ($self->{insideDescription})
            {
                $self->{curInfo}->{description} .= $origtext;
            }
        }
    }
    
    sub comment
    {
        my ($self, $comment) = @_;
        
        if ($self->{parsingList})
        {
            
        }
        else
        {
            if ($comment =~ /\/div/)
            {
                if($self->{insideDescription})
                {
                    $self->{insideDescription} = 0;
                    # remove spaces from start and end of description
                    $self->{curInfo}->{description} =~ s/^\s+//;
                    $self->{curInfo}->{description} =~ s/\s+$//;
                }
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
             
        return $html;
    }

    sub getSearchUrl
    {
	my ($self, $word) = @_;
	  
        # Url returned below is the for the search page, where $word is replaced by the search 
        return ('http://www.reservoir-jeux.com/recherche.php', ['search' => $word, 'secteurid' => '-1', 'dv' => '30']);
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
		
        return $url if $url =~ /^http:/;
        if ($url =~ /^\//)
        {
            return "http://www.reservoir-jeux.com".$url;
        }
        else
        {
            return "http://www.reservoir-jeux.com/".$url;
        }
    }

    sub getName
    {
        return "Reservoir Jeux";
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
