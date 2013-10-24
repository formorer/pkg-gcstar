package GCPlugins::GCbooks::GCNooSFere;

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
use utf8;

use GCPlugins::GCbooks::GCbooksCommon;

{
    package GCPlugins::GCbooks::GCPluginNooSFere;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            return if ( $self->{isFound} eq 2 );
            if (($tagname eq 'td') && ($attr->{class} eq 'onglet_bleu'))
            {
                $self->{isFound} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m/editionslivre.asp\?numitem=/i) && !($attr->{href} =~ m/numediteur=/i) && !($attr->{href} =~ m/tri=/i))
            {
                $self->{isTitle} = 1 ;
                $self->{isAuthor} = 0 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|/icarus/livres/auteur.asp\?NumAuteur=|i) && ($self->{isAuthor} eq 0))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|./editeur.asp\?numediteur=|i))
            {
                $self->{isPublisher} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|./serie.asp\?NumSerie=|i))
            {
                $self->{isSerie} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m/editionslivre.asp\?numitem=/i) && ($attr->{href} =~ m/numediteur=/i))
            {

                my $html = $self->loadPage( "http://www.noosfere.org/icarus/livres/" . $attr->{href}, 0, 1 );
                my $found = index($html,"Fiche livre&nbsp;: les &eacute;ditions");
                if ( $found >= 0 )
                {

                   while (index($html,"./niourf.asp?numlivre="))
                   {
                      $found = index($html,"./niourf.asp?numlivre=");
                      if ( $found >= 0 )
                      {
                         $html = substr($html, $found +length('./niourf.asp?numlivre='),length($html)- $found -length('./niourf.asp?numlivre='));
                         $self->{itemIdx}++;
                         $self->{itemsList}[$self->{itemIdx}]->{title} = $self->{saveTitle};
                         $self->{itemsList}[$self->{itemIdx}]->{authors} = $self->{saveAuthor};
                         $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.noosfere.org/icarus/livres/niourf.asp?numlivre=" . substr($html, 0, index($html,"\""));
                      }
                      else
                      {
                         last;
                      }

                   }
                }
                else
                {
                   $self->{itemIdx}++;
                   $self->{itemsList}[$self->{itemIdx}]->{title} = $self->{saveTitle};
                   $self->{itemsList}[$self->{itemIdx}]->{authors} = $self->{saveAuthor};
                   $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.noosfere.org/icarus/livres/" . $attr->{href};
                }
            }
            elsif ($tagname eq 'h1')
            {
                $self->{isTitle} = 1 ;
                $self->{isAuthor} = 0 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|./niourf.asp\?numlivre=|i))
            {
                $self->{itemIdx}++;
                $self->{itemsList}[$self->{itemIdx}]->{title} = $self->{saveTitle};
                $self->{itemsList}[$self->{itemIdx}]->{authors} = $self->{saveAuthor};
                $self->{itemsList}[$self->{itemIdx}]->{url} = "http://www.noosfere.org/icarus/livres/" . $attr->{href};
            }
            elsif (($tagname eq 'td') && ($attr->{class} eq 'onglet_biblio1'))
            {
                $self->{isAuthor} = 2 ;
            }
            elsif (($tagname eq 'table') && ($attr->{class} eq 'piedpage'))
            {
                $self->{isAuthor} = 0 ;
            }
        }
        else
        {
            if (($tagname eq 'mytpf') && ($attr->{id} eq 'TPFENDCOMMENTTPF'))
            {
                $self->{isDescription} = 0 ;
            }
            elsif (($tagname eq 'font') && ($attr->{class} eq 'TitreNiourf'))
            {
                $self->{isAnalyse} = 0 ;
                $self->{isTitle} = 1 ;
                $self->{isAuthor} = 0 ;
            }
            elsif (($tagname eq 'font') && ($attr->{class} eq 'AuteurNiourf'))
            {
                $self->{isAuthor} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|/icarus/livres/auteur.asp\?NumAuteur=|i) && ($self->{isAuthor} eq 1))
            {
                $self->{isAuthor} = 2 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|actu_mois.asp\?|i))
            {
                $self->{isPublication} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|editeur.asp\?numediteur=|i) && ($self->{curInfo}->{publisher} eq ''))
            {
                $self->{isPublisher} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|collection.asp\?NumCollection=|i) && ($self->{curInfo}->{serie} eq ''))
            {
                $self->{isSerie} = 1 ;
            }
            elsif (($tagname eq 'a') && ($attr->{href} =~ m|/icarus/livres/auteur.asp\?NumAuteur=|i) && ($self->{isTranslator} eq 1))
            {
                $self->{isTranslator} = 2 ;
            }
            elsif ($tagname eq 'br')
            {
                $self->{isAnalyseTrans} = 1 ;
            }
            elsif (($tagname eq 'font') && ($attr->{style} eq 'font-size:12px;') && ($self->{isAnalyse} eq 0))
            {
                $self->{isAnalyse} = 1 ;
            }
            elsif (($tagname eq 'img') && ($attr->{name} eq 'couverture'))
            {
                $self->{curInfo}->{cover} = "http://www.noosfere.org/icarus/livres/" . $attr->{src} ;
            }
            elsif (($tagname eq 'mytpf') && ($attr->{id} eq 'TPFSTARTCOMMENTTPF'))
            {
                $self->{isDescription} = 1 ;
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
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//g;
                $self->{saveTitle} = $origtext;
                $self->{saveAuthor} = '';
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAuthor} eq 1)
            {
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//g;
                if (($self->{saveAuthor} eq '') && ($origtext ne ''))
                {
                   $self->{saveAuthor} = $origtext;
                }
                elsif ($origtext ne '')
                {
                   $self->{saveAuthor} .= ', ';
                   $self->{saveAuthor} .= $origtext;
                }
                $self->{isAuthor} = 0 ;
            }
            elsif ($self->{isPublisher})
            {
                $self->{itemsList}[$self->{itemIdx}]->{edition} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isSerie})
            {
                $self->{itemsList}[$self->{itemIdx}]->{serie} = $origtext;
                $self->{isSerie} = 0 ;
            }
            elsif ($self->{isFound} eq 1)
            {
                # Enleve les blancs en debut de chaine
                $origtext =~ s/^\s+//;
                # Enleve les blancs en fin de chaine
                $origtext =~ s/\s+$//g;
                if ($origtext eq 'Fiche livre')
                {
                   $self->{itemIdx}++;
                   $self->{itemsList}[$self->{itemIdx}]->{url} = $self->{loadedUrl};
                   $self->{isFound} = 2 ;
                }
                else
                {
                   $self->{isFound} = 0 ;
                }
            }
        }
       	else
        {
            # Enleve les blancs en debut de chaine
            $origtext =~ s/^\s+//;
            # Enleve les blancs en fin de chaine
            $origtext =~ s/\s+$//g;
            if ($self->{isTitle} eq '1')
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0 ;
            }
            elsif ($self->{isAnalyse} eq 1)
            {
               my $found = index($origtext," pages");
               if ( $found >= 0 )
               {
                  $self->{curInfo}->{pages} = substr($origtext, 0, $found);
               }
               $found = index($origtext,"ISBN : ");
               if ( $found >= 0 )
               {
                  $self->{curInfo}->{isbn} = substr($origtext, $found +length('ISBN : '),length($origtext)- $found -length('ISBN : '));
               }

                $self->{isAnalyse} = 2 ;
            }
            elsif ($self->{isAnalyseTrans})
            {
                $self->{isTranslator} = 1 if ($origtext =~ m/Traduction/i);

                $self->{isAnalyseTrans} = 0 ;
            }
            elsif ($self->{isAuthor} eq 2)
            {
                if (($self->{curInfo}->{authors} eq '') && ($origtext ne ''))
                {
                   $self->{curInfo}->{authors} = $origtext;
                }
                elsif ($origtext ne '')
                {
                   $self->{curInfo}->{authors} .= ', ';
                   $self->{curInfo}->{authors} .= $origtext;
                }
                $self->{isAuthor} = 1 ;
            }
            elsif ($self->{isPublisher})
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{isPublisher} = 0 ;
            }
            elsif ($self->{isSerie})
            {
                $self->{curInfo}->{serie} = $origtext;
                $self->{isSerie} = 0 ;
            }
            elsif ($self->{isPublication})
            {
                $self->{curInfo}->{publication} = $origtext;
                $self->{isPublication} = 0 ;
            }
            elsif ($self->{isTranslator} eq 2)
            {
                $self->{curInfo}->{translator} = $origtext;
                $self->{isTranslator} = 0 ;
            }
            elsif ($self->{isDescription})
            {
                if ($origtext =~ m/Pas de texte sur la quatri.me de couverture\./i)
                {
                }
                else
                {
                   $self->{curInfo}->{description} .= $origtext ."\n";
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
            title => 1,
            authors => 1,
            publication => 0,
            format => 0,
            edition => 1,
            serie => 1,
        };

        $self->{saveTitle} = '';
        $self->{saveAuthor} = '';
        $self->{isFound} = 0;
        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isPublisher} = 0;
        $self->{isPublication} = 0;
        $self->{isSerie} = 0;
        $self->{isDescription} = 0;
        $self->{isTranslator} = 0;
        $self->{isAnalyseTrans} = 0;
        $self->{isAnalyse} = 0;

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
            # Le descriptif pouvant contenir des balises html je le repere maintenant
            my $found = index($html,"Id=\"R");
            if ( $found >= 0 )
            {
               my $html2 = substr($html, $found +length('Id="R'),length($html)- $found -length('Id="R'));
               my $found2 = index($html2,"<TD class=\"noocell_fs15\" valign=\"top\">");
               if ( $found2 >= 0 )
               {
                  $html2 = substr($html2, $found2 +length('<TD class="noocell_fs15" valign="top">'),length($html2)- $found2 -length('<TD class="noocell_fs15" valign="top">'));
               }

               $found2 = index($html2,"</TD>");
               if ( $found2 >= 0 )
               {
                  $html2 = substr($html2, 0, $found2);
               }

               $html2 =~ s|<li>|\n* |gi;
               $html2 =~ s|<br>|\n|gi;
               $html2 =~ s|<br />|\n|gi;
               $html2 =~ s|<b>||gi;
               $html2 =~ s|</b>||gi;
               $html2 =~ s|<i>||gi;
               $html2 =~ s|</i>||gi;
               $html2 =~ s|<p>|\n|gi;
               $html2 =~ s|</p>||gi;
               $html2 =~ s|</h4>||gi;
               $html2 =~ s|\x{92}|'|g;
               $html2 =~ s|&#146;|'|gi;
               $html2 =~ s|&#149;|*|gi;
               $html2 =~ s|&#156;|oe|gi;
               $html2 =~ s|&#133;|...|gi;
               $html2 =~ s|\x{85}|...|gi;
               $html2 =~ s|\x{8C}|OE|gi;
               $html2 =~ s|\x{9C}|oe|gi;

               $html = substr($html, 0, $found) . "><mytpf id=\"TPFSTARTCOMMENTTPF\">" . $html2 ."</mytpf><mytpf id=\"TPFENDCOMMENTTPF\"></mytpf>";

            }

            $html =~ s|<b><p>||gmi;
            $html =~ s|<br><br>|<br>|gmi;
            $html =~ s|<br><|<|gmi;
        }
        
        return $html;
    }
    
    sub getSearchUrl
    {
        my ($self, $word) = @_;
	
        if ($self->{searchField} eq 'isbn')
        {
           return "http://www.noosfere.org/icarus/livres/cyborg_livre.asp?mini=1000&maxi=3000&mode=Idem&EtOuParution=NS&isbn=". $word;
        }
        else
        {
           return "http://www.noosfere.org/icarus/livres/cyborg_livre.asp?mini=1000&maxi=3000&mode=Idem&EtOuParution=NS&titre=". $word;
        }
    }
    
    sub getItemUrl
    {
        my ($self, $url) = @_;
		
        return $url if $url;
        return 'http://www.noosfere.org/';
    }

    sub getName
    {
        return "nooSFere";
    }
    
    sub getCharset
    {
        my $self = shift;
        return "ISO-8859-15";
    }

    sub getAuthor
    {
        return 'TPF';
    }
    
    sub getLang
    {
        return 'FR';
    }

    sub getSearchFieldsArray
    {
        return ['isbn', 'title'];
    }
}

1;
