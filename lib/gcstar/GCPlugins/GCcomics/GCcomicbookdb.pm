package GCPlugins::GCcomics::GCcomicbookdb;

###################################################
#
#  Copyright 2005-2012 Christian Jodar
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

use GCPlugins::GCcomics::GCcomicsCommon;

{

    package GCPlugins::GCcomics::GCPlugincomicbookdb;

    use LWP::Simple qw($ua);
    use HTTP::Cookies;

    use base qw(GCPlugins::GCcomics::GCcomicsPluginsBase);

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;

        if ($self->{pass} == 1)
        {
            # First pass, searching for series name
            if ($tagname eq "h2")
            {
                $self->{isAtResults} = 1;
            }
            if (   ($tagname eq "a")
                && ($self->{isAtResults})
                && !($attr->{href} =~ m/ebay\.com/))
            {
                $self->{isCollection} = 1;
                $self->{itemIdx}++;

                $self->{itemsList}[ $self->{itemIdx} ]->{nextUrl} =
                  "http://www.comicbookdb.com/" . $attr->{href};
            }
        }
        else
        {
            # Second pass, or fetching item info
            if ($self->{parsingList})
            {

                if (   ($tagname eq "tbody")
                    && ($self->{isResultsTable})
                    && ($self->{isSpecialIssue} == 1))
                {
                    $self->{isSpecialIssue} = 2;
                }
                # Parsing issue list
                if (($tagname eq "a") && ($self->{isResultsTable}))
                {
                    if ($attr->{href} =~ m/javascript/)
                    {
                        # Multiple editions of the one issue, need to be
                        # handled differently
                        $self->{isSpecialIssue} = 1;
                    }
                    elsif ($attr->{href} =~ m/storyarc.php/)
                    {
                        # Prevent story arcs from populating lists
                    }
                    elsif ($self->{isSpecialIssue} == 1)
                    {
                        $self->{resultsTableColumn}++;
                        if ($self->{resultsTableColumn} == 1)
                        {
                            $self->{isSpecialIssueNo} = 1;
                            $self->{isIssue}          = 1;
                            $self->{itemIdx}++;
                            $self->{itemsList}[ $self->{itemIdx} ]->{url} =
                              "http://www.comicbookdb.com/" . $attr->{href};
                        }
                        elsif ($self->{resultsTableColumn} == 2)
                        {
                            $self->{isTitle}        = 1;
                            $self->{isSpecialTitle} = 1;
                        }
                    }
                    elsif ($self->{isSpecialIssue} == 2)
                    {
                        $self->{itemIdx}++;
                        $self->{itemsList}[ $self->{itemIdx} ]->{url} =
                          "http://www.comicbookdb.com/" . $attr->{href};
                        $self->{isTitle} = 1;
                    }
                    else
                    {
                        $self->{resultsTableColumn}++;
                        if ($self->{resultsTableColumn} == 1)
                        {
                            $self->{isIssue} = 1;
                            $self->{itemIdx}++;
                            $self->{itemsList}[ $self->{itemIdx} ]->{url} =
                              "http://www.comicbookdb.com/" . $attr->{href};
                        }
                        elsif ($self->{resultsTableColumn} == 2)
                        {
                            $self->{isTitle} = 1;
                        }
                    }
                }
            }
            else
            {
                # Fetching item info
                if (   ($tagname eq "span")
                    && ((index $attr->{class}, "page_headline") > -1))
                {
                    $self->{insideHeadline} = 1;
                }
                elsif (($tagname eq "a")
                    && ($self->{insideHeadline})
                    && ($attr->{href} =~ m/title.php/))
                {
                    $self->{insideName} = 1;
                }
                elsif (($tagname eq "a")
                    && ($self->{insideHeadline})
                    && ($attr->{href} =~ m/issue_number.php/))
                {
                    $self->{insideNumber} = 1;
                }
                elsif (($tagname eq "a") && ($self->{nextisWriters}))
                {
                    $self->{insideWriters}    = 1;
                    $self->{insidePencillers} = 0;
                    $self->{insideColorists}  = 0;
                }
                elsif (($tagname eq "a") && ($self->{nextisPencillers}))
                {
                    $self->{insideWriters}    = 0;
                    $self->{insidePencillers} = 1;
                    $self->{insideColorists}  = 0;
                }
                elsif (($tagname eq "a") && ($self->{nextisColorists}))
                {
                    $self->{insideWriters}    = 0;
                    $self->{insidePencillers} = 0;
                    $self->{insideColorists}  = 1;
                }
                elsif (($tagname eq "a") && ($attr->{href} =~ /imprint.php/))
                {
                    $self->{insidePublisher} = 1;
                }
                elsif (($tagname eq "a")
                    && ($attr->{href} =~ /publisher.php/)
                    && (!$self->{curInfo}->{publisher}))
                {
                    $self->{insidePublisher} = 1;
                }
                elsif (($tagname eq "a") && ($attr->{href} =~ /coverdate.php/))
                {
                    $self->{insideCoverDate} = 1;
                }
                if (   ($tagname eq "span")
                    && ((index $attr->{class}, "test") > -1)
                    && ((index $attr->{class}, "page_subheadline") > -1))
                {
                    $self->{insideSubHeadline} = 1;
                }
                elsif (($tagname eq "a")
                    && ($attr->{href} =~ /^graphics\/comic_graphics\//))
                {
                    $self->{curInfo}->{image} =
                      "http://www.comicbookdb.com/" . $attr->{href};
                }
                elsif (($tagname eq "img")
                    && ($attr->{src} =~ /^graphics\/comic_graphics\//)
                    && (!$self->{curInfo}->{image}))
                {
                    $self->{curInfo}->{image} =
                      "http://www.comicbookdb.com/" . $attr->{src};
                }

            }
        }
    }

    sub end
    {
        my ($self, $tagname) = @_;
        $self->{inside}->{$tagname}--;

        if ($self->{isResultsTable})
        {
            if ($tagname eq "table")
            {
                $self->{isResultsTable} = 0;
            }
            elsif ($tagname eq "tr")
            {
                $self->{resultsTableColumn} = 0;
            }
        }

        if ($tagname eq "tbody")
        {
            $self->{isSpecialIssue} = 0;
        }
        elsif ($tagname eq "span")
        {
            $self->{insideHeadline}    = 0;
            $self->{insideSubHeadline} = 0;
            $self->{insideNumber}      = 0;
        }
        elsif ($tagname eq "td")
        {
            $self->{isAtResults}      = 0;
            $self->{nextisWriters}    = 0;
            $self->{nextisPencillers} = 0;
            $self->{nextisColorists}  = 0;
            $self->{insideWriters}    = 0;
            $self->{insidePencillers} = 0;
            $self->{insideColorists}  = 0;
        }
        elsif ($tagname eq "a")
        {
            $self->{insidePublisher} = 0;
            $self->{insideCoverDate} = 0;
        }
    }

    sub text
    {
        my ($self, $origtext) = @_;

        return if ($origtext eq " ");

        return if ($self->{parsingEnded});

        if ($self->{parsingList})
        {
            if ($self->{isCollection})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{series} = $origtext;
                $self->{isCollection} = 0;
            }
            if ($origtext eq "Cover Date")
            {
                $self->{isResultsTable} = 1;
            }
            if ($self->{isIssue})
            {
                $self->{itemsList}[ $self->{itemIdx} ]->{volume} = $origtext;
                $self->{isIssue} = 0;
            }
            if ($self->{isSpecialIssueNo})
            {
                $self->{specialIssueNo}   = $origtext;
                $self->{isSpecialIssueNo} = 0;
            }
            if ($self->{isTitle})
            {
                if ($self->{isSpecialIssue} == 2)
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{volume} =
                      $self->{specialIssueNo};
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} =
                      $self->{specialTitle} . $origtext;
                }
                else
                {
                    $self->{itemsList}[ $self->{itemIdx} ]->{title} = $origtext;
                }
                $self->{isTitle} = 0;
            }
            if ($self->{isSpecialTitle})
            {
                $self->{specialTitle}   = $origtext;
                $self->{isSpecialTitle} = 0;
            }
        }
        else
        {
            if ($self->{insideName})
            {
                $self->{curInfo}->{series} = $origtext;
                #$self->{curInfo}->{series} =~ s/(\s\([0-9]*\))$//;
                $self->{insideName} = 0;
            }
            elsif (($self->{insideNumber}) && ($origtext =~ /^\s*#(\d+)/))
            {
                # volume where #XX is in <A HREF... tag, '-' is not
                $self->{curInfo}->{volume} = $1;
                $self->{insideNumber} = 0;
            }
            elsif (($self->{insideHeadline}) && ($origtext =~ /-\s#(\d+)/))
            {
                # volume where #XX isn't in <A HREF... tag
                $self->{curInfo}->{volume} = $1;
                $self->{insideNumber} = 0;
            }
            elsif (($self->{insideHeadline}) && ($origtext =~ /-\s*TPB/))
            {
                # Trade paperback
                $self->{curInfo}->{series} .= " TPB";

                # Get volume number.  Default to 1.
                if ($origtext =~ /vol\. (\d+)/)
                {
                    $self->{curInfo}->{volume} = $1;
                }
                else
                {
                    $self->{curInfo}->{volume} = 1;
                }
                $self->{insideNumber} = 0;
            }
            elsif (($self->{insideHeadline}) && ($origtext =~ /vol\. (\d+)/))
            {
                $self->{curInfo}->{volume} = $1;
                $self->{insideNumber} = 0;
            }
            elsif (($self->{insideHeadline}) && ($origtext =~ /-\s*Annual\s*(\d+)/))
            {
                # Annual volume where #XX isn't in <A HREF... tag
                $self->{curInfo}->{volume} = $1;
                $self->{curInfo}->{series} .= " Annual";
                $self->{insideNumber} = 0;
            }
            elsif (($self->{insideSubHeadline}) && ($origtext =~ /\"(.*)\"/))
            {
                $self->{curInfo}->{title} = $1;

                # Get printing or other note if present
                if ($origtext =~ /\((.*)\)/)
                {
                    $self->{curInfo}->{title} .= " (" . $1 . ")";
                }
            }
            elsif ($self->{insidePublisher})
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{insidePublisher} = 0;
            }
            elsif ($origtext eq "Writer(s):")
            {
                $self->{nextisWriters}    = 1;
                $self->{nextisPencillers} = 0;
                $self->{nextisColorists}  = 0;
            }
            elsif ($origtext eq "Penciller(s):")
            {
                $self->{nextisWriters}    = 0;
                $self->{nextisPencillers} = 1;
                $self->{nextisColorists}  = 0;
            }
            elsif ($origtext eq "Colorist(s):")
            {
                $self->{nextisWriters}    = 0;
                $self->{nextisPencillers} = 0;
                $self->{nextisColorists}  = 1;
            }
            elsif (($origtext eq "Letterer(s):")
                || ($origtext eq "Inker(s):")
                || ($origtext eq "Editor(s):")
                || ($origtext eq "Cover Artist(s):")
                || ($origtext eq "Characters:")
                || ($origtext eq "Groups:"))
            {
                $self->{nextisWriters}    = 0;
                $self->{nextisPencillers} = 0;
                $self->{nextisColorists}  = 0;
            }
            elsif ($self->{insideWriters})
            {
                if ($self->{curInfo}->{writer} eq "")
                {
                    $self->{curInfo}->{writer} = $origtext;
                }
                elsif ((index $self->{curInfo}->{writer}, $origtext) == -1)
                {
                    $self->{curInfo}->{writer} .= ", ";
                    $self->{curInfo}->{writer} .= $origtext;
                }

                $self->{insideWriters} = 0;
            }
            elsif ($self->{insidePencillers})
            {
                if ($self->{curInfo}->{illustrator} eq "")
                {
                    $self->{curInfo}->{illustrator} = $origtext;
                }
                elsif ((index $self->{curInfo}->{illustrator}, $origtext) == -1)
                {
                    $self->{curInfo}->{illustrator} .= ", ";
                    $self->{curInfo}->{illustrator} .= $origtext;
                }

                $self->{insidePencillers} = 0;
            }
            elsif ($self->{insideColorists})
            {
                if ($self->{curInfo}->{colourist} eq "")
                {
                    $self->{curInfo}->{colourist} = $origtext;
                }
                elsif ((index $self->{curInfo}->{colourist}, $origtext) == -1)
                {
                    $self->{curInfo}->{colourist} .= ", ";
                    $self->{curInfo}->{colourist} .= $origtext;
                }

                $self->{insideColorists} = 0;
            }
            elsif ($origtext eq "Synopsis: ")
            {
                $self->{nextisSynopsis} = 1;
            }
            elsif ($self->{nextisSynopsis})
            {
                if ($origtext !~ /None entered./)
                {
                    $self->{curInfo}->{synopsis} = $origtext;
                    $self->{curInfo}->{synopsis} =~ s/^(\s)*//;
                    $self->{curInfo}->{synopsis} =~ s/(\s)*$//;
                }
                $self->{nextisSynopsis} = 0;
            }
            elsif ($self->{insideCoverDate})
            {
                $self->{curInfo}->{printdate} = $origtext;
                $self->{curInfo}->{printdate} =~ s/^(\s)*//;

                # Translate date string to date
                $self->{curInfo}->{printdate} =
                  GCUtils::strToTime($self->{curInfo}->{printdate}, "%B %Y");
                $self->{curInfo}->{publishdate} = $self->{curInfo}->{printdate};
            }
        }
    }

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();

        $self->{ua}->cookie_jar(HTTP::Cookies->new);

        bless($self, $class);

        $self->{isResultsTable}     = 0;
        $self->{itemIdx}            = 0;
        $self->{resultsTableColumn} = 0;
        $self->{curName}            = undef;
        $self->{curUrl}             = undef;

        return $self;
    }

    sub getReturnedFields
    {
        my $self = shift;

        if ($self->{pass} == 1)
        {
            $self->{hasField} = {series => 1,};
        }
        else
        {
            $self->{hasField} = {
                title  => 1,
                volume => 1,
            };
        }
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        $self->{parsingEnded} = 0;

        return $html;
    }

    sub getSearchUrl
    {
        my ($self, $word) = @_;

        $word =~ s/\+%28\d{4}%29$//;    # strip year from end of $word (title)

        # Grab the home page first, or the pages fetched are blank
        # (who knows why... must be something funky with the website)
        my $response = $ua->get('http://www.comicbookdb.com/');

        return
          "http://www.comicbookdb.com/search.php?form_search=$word&form_searchtype=Title";
    }

    sub getItemUrl
    {
        my ($self, $url) = @_;
        return $url if $url =~ /^http:/;

        return "http://www.comicbookdb.com" . $url;
    }

    sub getNumberPasses
    {
        return 2;
    }

    sub getName
    {
        return "Comic Book DB";
    }

    sub getAuthor
    {
        return 'Zombiepig';
    }

    sub getLang
    {
        return 'EN';
    }
}

1;
