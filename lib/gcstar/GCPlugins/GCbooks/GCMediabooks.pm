package GCPlugins::GCbooks::GCMediabooks;

###################################################
#
#  Copyright 2005-2006 Tian
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

use GCPlugins::GCbooks::GCbooksCommon;

{
    package GCPlugins::GCbooks::GCPluginMediabooks;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    use Encode;
    use HTML::Entities;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {

            if (($tagname eq 'font') && ($attr->{class} eq 'font4Copy'))
            {
                $self->{isBook} = 1 ;
                $self->{isUrl} = 1 ;
                $self->{isDescription} = 0 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|/artigos/popUp_detalhe.jsp|i) && ($self->{isBook}) && ($self->{isUrl}))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                my $found = index($self->{itemsList}[$self->{itemIdx}]->{url},"'");
                if ( $found >= 0 )
                {
                   $self->{itemsList}[$self->{itemIdx}]->{url} = substr($self->{itemsList}[$self->{itemIdx}]->{url}, $found +length("'"),length($self->{itemsList}[$self->{itemIdx}]->{url})- $found -length("'"));
                   $found = index($self->{itemsList}[$self->{itemIdx}]->{url},"'");
                   if ( $found >= 0 )
                   {
                      $self->{itemsList}[$self->{itemIdx}]->{url} = substr($self->{itemsList}[$self->{itemIdx}]->{url}, 0, $found);
                   }
                   $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.mediabooks.pt" .$self->{itemsList}[$self->{itemIdx}]->{url};
                }

                $self->{isTitle} = 1 ;
                $self->{isUrl} = 0 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|/autores/index.jsp|i) && ($self->{isBook}))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|/editores/index.jsp|i) && ($self->{isBook}))
            {
                $self->{isPublisher} = 1 ;
            }
            elsif (($tagname eq 'input') && ($attr->{type} eq 'hidden'))
            {
                $self->{isBook} = 0 ;
            }
        }
        else
        {
            if (($tagname eq 'a') && ($attr->{href} =~ m|/autores/index.jsp|i))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|/editores/index.jsp|i))
            {
                $self->{isPublisher} = 1 ;
            }
            elsif ($self->{isISBN} eq 1)
            {
                $self->{isISBN} = 2 ;
            }
            elsif (($tagname eq 'span') && ($self->{isTitle}))
            {
                $self->{isTitle} = 2 ;
            }
            elsif (($tagname eq 'span') && ($attr->{class} eq 'font4Copy'))
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'img') && ($attr->{src} =~ m|/artigos/imagens/|i))
            {
                if ($origtext =~ m|/artigos/imagens/livros|i)
                {
                }
                else
                {
                   $self->{curInfo}->{cover} = 'http://www.mediabooks.pt' .$attr->{src};
                }

                $self->{isTitle} = 1 ;
            }
        }
    }

    sub end
    {
		my ($self, $tagname) = @_;

        $self->{isFound} = 0 ;
        $self->{inside}->{$tagname}--;
    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if ($self->{isTitle})
            {
                $self->{itemsList}[$self->{itemIdx}]->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor} eq 1)
            {
                # Enleve les retours chariots
                $origtext =~ s/\n//g;
                $origtext =~ s/\r//g;
                if (($self->{itemsList}[$self->{itemIdx}]->{authors} eq '') && ($origtext ne ''))
                {
                   $self->{itemsList}[$self->{itemIdx}]->{authors} = $origtext;
                }
                elsif ($origtext ne '')
                {
                   $self->{itemsList}[$self->{itemIdx}]->{authors} .= ', ';
                   $self->{itemsList}[$self->{itemIdx}]->{authors} .= $origtext;
                }
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                $self->{itemsList}[$self->{itemIdx}]->{edition} = $origtext;
                $self->{isPublisher} = 0 ;
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//g;
            if ($self->{isTitle} eq '2')
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor} eq 1)
            {
                if ($origtext ne '')
                {
                   $self->{curInfo}->{authors} .= $origtext;
                   $self->{curInfo}->{authors} .= ",";
                }
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isISBN} = 1 if ($origtext =~ m/ISBN/i);
                $self->{isFormat} = 1 if ($origtext =~ m/Formato/i);
                $self->{isDescription} = 1 if ($origtext =~ m/Breve Descri/i);
                $self->{isPublication} = 1 if ($origtext =~ m/Ano de Edi/i);
                $self->{isPage} = 1 if ($origtext =~ m/P.ginas/i);

                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isISBN} eq 2)
            {
                $self->{curInfo}->{isbn} = $origtext;
                $self->{isISBN} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isFormat})
            {
                $self->{curInfo}->{format} = $origtext;
                $self->{isFormat} = 0 ;
            }
            elsif ($self->{isPublication})
            {
                $self->{curInfo}->{publication} = $origtext;
                $self->{isPublication} = 0 ;
            }
            elsif ($self->{isPage})
            {
                $self->{curInfo}->{pages} = $origtext;
                $self->{isPage} = 0 ;
            }
            elsif ($self->{isDescription})
            {
                $self->{curInfo}->{description} .= $origtext;
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
            publication => 0,
            format => 0,
            edition => 1,
        };

        $self->{isFound} = 0;
        $self->{isBook} = 0;
        $self->{isUrl} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isFormatPublication} = 0;
        $self->{isPublisher} = 0;
        $self->{isISBN} = 0;
        $self->{isPublication} = 0;
        $self->{isFormat} = 0;
        $self->{isPage} = 0;
        $self->{isDescription} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
        }
        else
        {
            $html =~ s|\n||gi;
            $html =~ s|\r||gi;
            $html =~ s|\t||gi;

            $html =~ s|<li>|\n* |gi;
            $html =~ s|<br>|\n|gi;
            $html =~ s|<br />|\n|gi;
            $html =~ s|<b>||gi;
            $html =~ s|</b>||gi;
            $html =~ s|<i>||gi;
            $html =~ s|</i>||gi;
            $html =~ s|<p>|\n|gi;
            $html =~ s|</p>||gi;
            $html =~ s|</h4>||gi;
            $html =~ s|\x{92}|'|g;
            $html =~ s|&#146;|'|gi;
            $html =~ s|&#149;|*|gi;
        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;
	
        if ($self->{searchField} eq 'isbn')
        {
           return ('http://www.mediabooks.pt/pesquisa/result_pesq.jsp', ["v_sec_id" => "1", "v_prev_sec_id" => "", "v_pes_id" => "2", "v_pesquisa" => "$word", "image.x" => "5", "image.y" => "7"] );
        }
        else
        {
           return ('http://www.mediabooks.pt/pesquisa/result_pesq.jsp', ["v_sec_id" => "1", "v_prev_sec_id" => "", "v_pes_id" => "1", "v_pesquisa" => "$word", "image.x" => "5", "image.y" => "7"] );
        }

    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;
		
        return $url if $url;
        return 'http://www.mediabooks.pt/';
    }

    sub getName
    {
        return "Mediabooks";
    }
    
    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'PT';
    }

    sub getSearchFieldsArray
    {
        return ['isbn', 'title'];
    }

}

1;
