package GCExport::GCExportHTML;

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

use GCExport::GCExportBase;

{
    package GCExport::GCExporterHTML;


    use File::Copy;
    use File::Basename;
    use XML::Simple;
    use base qw(GCExport::GCExportBaseClass);
    use GCUtils 'glob';

    our $FieldsList = 'GCSfields';
    our $GroupsList = 'GCSgroups';

    sub new
    {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        
        $self->{genericModels} = 0;
	
        bless ($self, $class);
        return $self;
    }

    sub getName
    {
        my $self = shift;
        
        return "HTML";
    }
    
    sub getSuffix
    {
        my $self = shift;
        
        return ".html";
    }
    
    sub needsUTF8
    {
        my $self = shift;
    
        return 1;
    }
    
    sub getModels
    {
        my $self = shift;
        
        return [];
    }

    sub setModelsDir
    {
        my $self = shift;
        $self->{genericModelsDir} = $ENV{GCS_SHARE_DIR}.'/html_models/GCstar';
        if ($self->{model})
        {
            $self->{modelsDir} = $ENV{GCS_SHARE_DIR}.'/html_models/'.$self->{model}->getName;
            if ((! $self->{model}->getName) || (! -e $self->{modelsDir}))
            {
                $self->{modelsDir} = $self->{genericModelsDir};
                $self->{genericModels} = 1;
            }
        }
    }

    sub getOptions
    {
        my $self = shift;
        $self->{modelsFiles} = '';

        $self->setModelsDir;

        my $defaultModel = '';
        $self->{isGeneric} = {};
        foreach (glob $self->{modelsDir}.'/*')
        {
            next if ($_ =~ /\/CVS$/) || ($_ =~ /\.png$/);
            (my $mod = basename($_)) =~ s/_/ /g;
            $self->{modelsFiles} .= $mod.',';
            $defaultModel = $mod if !$defaultModel;
            $self->{isGeneric}->{$mod} = $self->{genericModels};
        }
        $self->{genericAdded} = 0;
        if (!$self->{genericModels})
        {
            # Previous one was specific, we also add the generic ones.
            foreach (glob $self->{genericModelsDir}.'/*')
            {
                next if ($_ =~ /\/CVS$/) || ($_ =~ /\.png$/);
                (my $mod = basename($_)) =~ s/_/ /g;
                
                next if exists $self->{isGeneric}->{$mod};
                $self->{modelsFiles} .= $mod.',';
                $self->{isGeneric}->{$mod} = 1;
                $self->{genericAdded} = 1;
            }
        }
        $self->{modelsFiles} .= 'UseFile,';
        return [
        {
            name => 'template',
            type => 'options',
            label => 'FileTemplate',
            valuesList => $self->{modelsFiles},
            default => $defaultModel,
            changedCallback => sub {shift; $self->checkFileField(@_)},
            buttonLabel => 'Preview',
            buttonCallback => sub {shift; $self->preview(@_)}
        },
                      
        {
            name => 'modelFile',
            type => 'file',
            label => 'TemplateExternalFile',
            default => '',
            insensitive => 1,
        },
	    
        {
            name => 'title',
            type => 'short text',
            label => 'Title',
            default => 'Items list',
        },
	    
    	{
            name => 'imgHeight',
            type => 'number',
            label => 'HeightImg',
            default => 160,
            min => 50,
            max => 500,
        },   
                        
        {
            name => 'withJs',
            type => 'yesno',
            label => 'WithJS',
            default => '1'
        },

        {
            name => 'open',
            type => 'yesno',
            label => 'OpenFileInBrowser',
            default => '0'
        },

        ]
    }
    
    sub getNewPictureHeight
    {
        my $self = shift;
        return $self->{options}->{imgHeight};
    }

    sub checkFileField
    {
        my ($self, $data) = @_;
        my ($parent, $list) = @{$data};
        return if ! $parent->{options}->{modelFile};
        my $model = $list->getValue ;
        $parent->{options}->{modelFile}->set_sensitive($model eq 'UseFile');
        $parent->{fieldsSelection}->set_sensitive($self->{isGeneric}->{$model})
            if $parent->{fieldsSelection};
    }

    sub preview
    {
        my ($self, $data) = @_;
        my ($parent, $list) = @{$data};
        (my $template = $list->getValue) =~ s/ /_/g;
        my $dialog = new Gtk2::Dialog($self->getLang->{Preview}.' - '.$list->getValue,
                                      $parent,
                                      [qw/modal destroy-with-parent/],
                                      'gtk-ok' => 'ok',
                                     );
                                             
        my $picFile;
        if ($self->{isGeneric}->{$template})
        {
            $picFile = $self->{genericModelsDir}.'/'.$template.'.png';
        }
        else
        {
            $picFile = $self->{modelsDir}.'/'.$template.'.png';
        }
        if (-f $picFile)
        {
            my $image = Gtk2::Image->new_from_file($picFile);
            $image->set_padding(10,10);
            $dialog->vbox->pack_start($image,0,0,0);
        }
        else
        {
            my $label = new Gtk2::Label;
            $label->set_markup('<b>'.$self->getLang->{NoPreview}.'</b>');
            $dialog->vbox->pack_start($label,1,1,0);
            $dialog->set_default_size(300,300);
        }
        $dialog->vbox->show_all;
        $dialog->run;
        $dialog->destroy;
        $parent->showMe;
    }
    
    sub wantsFieldsSelection
    {
        my $self = shift;
        return 1;
        return $self->{genericAdded} || $self->{genericModels};
    }
    
    sub wantsImagesSelection
    {
        return 1;
    }
    
    sub wantsOsSeparator
    {
        return 0;
    }    

    sub wantsSort
    {
        return 1;
    }

    sub transformData
    {
        my ($self, $item, $field, $asATable) = @_;
        
        my $data = $item->{$field};
        if ($asATable)
        {
            return '' if !$data;
            my $result = '';
            my $i = 1;
            foreach (@{$data})
            {
                my $class = ($i % 2) ? 'even' : 'odd';
                $result .= " <tr class=\"$class\">\n";
                foreach my $item(@{$_})
                {
                    $result .= "  <td>$item</td>\n";
                }
                $result .= " </tr>\n";
                $i++;
            }
            return $result;
        }
        else
        {
            my $value = $self->transformValue($data, $field);
            $value =~ s|\n|<br />|g;
            return $value;
        }
    }
    
    sub getValues
    {
        my ($self, $values, $filter) = @_;
        my $needFilter = (length($filter) > 2);
        my @result;
        if ($values eq $GroupsList)
        {
            # We generate the list of group for the selected fields
            my %groups;
            foreach (@{$self->{options}->{fields}})
            {
                my $group = $self->{options}->{fieldsInfo}->{$_}->{group};
                $groups{$group} = 1;
            }
            foreach (@{$self->{model}->{groups}})
            {
                my $group = $_->{id};
                push @result, $group if $groups{$group};
            }
        }
        else
        {
            # We could have a group name or a list of fields types
            my $type;
            my $group;
            foreach (@{$self->{options}->{fields}})
            {
                $type = $self->{options}->{fieldsInfo}->{$_}->{type};
                $group = $self->{options}->{fieldsInfo}->{$_}->{group};
                push @result, $_
                    if ($type ne 'triple list')
                    && (($group =~ /^$values$/i) || ($values eq $FieldsList))
                    && (!$needFilter || ($needFilter && ($filter =~ /$type/)));
            }
        }
        return \@result;        
    }
    
    sub preProcess
    {
        my $self =  shift;

        $self->{errors} = 0;
        $self->setModelsDir;
        my $template = $self->{options}->{template};
        my $file;
        my $model;
        if ($template eq 'UseFile')
        {
            $file = $self->{options}->{modelFile};
            if ( ! -e $file)
            {
                $self->{errors} = $self->getLang->{ModelNotFound};
                return 0;
            }
        }
        else
        {
            $template =~ s/ /_/;
            if ($self->{isGeneric}->{$template})
            {
                $file = $self->{genericModelsDir}.'/'.$self->{options}->{template};
            }
            else
            {
                $file = $self->{modelsDir}.'/'.$self->{options}->{template};
            }

            $file =~ s/"//g;
            #"
        }
        # The problem should only happen when using command line, so a die is enough.
        open FILE, $file or die "\nModel $template doesn't exist for this kind of collection";
        binmode(FILE, ':utf8' );
        $model = do { local $/; <FILE> };
        close FILE;

        if ($model =~ /^<metamodel>/)
        {
            my $xs = XML::Simple->new;
            my $meta = $xs->XMLin($model,
                                  ForceArray => ['field']);
            open FILE, $self->{genericModelsDir}.'/'.$meta->{model};
            binmode(FILE, ':utf8' );
            $model = do { local $/; <FILE> };
            close FILE;
            $self->{options}->{fields} = $meta->{fields}->{field};
        }

        if ($self->{options}->{withJs})
        {
            $model =~ s/(\[JAVASCRIPT\])|(\[\/JAVASCRIPT\])//gms;
            $model =~ s/\[NOJAVASCRIPT\].*?\[\/NOJAVASCRIPT\]//gms;
        }
        else
        {
            $model =~ s/\[JAVASCRIPT\].*?\[\/JAVASCRIPT\]//gms;
            $model =~ s/(\[NOJAVASCRIPT\])|(\[\/NOJAVASCRIPT\])//gms;
        }

        # If collection does not manage lendings, remove the LENDING blocks
        $model =~ s|\[LENDING\](.*?)\[/LENDING\]| $self->{model}->{hasLending} ? $1 : '' |ems;

        #Loops
        while ($model =~ m/\[LOOP([0-9]+)?\s+values=([^\s]*?)\s+idx=([^\s]*?)(\s+filter=([^\s]*?))?\]\n?(.*?)\n\s*\[\/LOOP\1\]/gms)
        {
            my $loopNumber = $1;
            my $values = $2;
            my $index = $3;
            my $filter = ','.$5.',';
            my $motif = $6;
            my $valuesArray = $self->getValues($values, $filter);
            my $string;
            foreach my $value(@$valuesArray)
            {
                (my $line = $motif) =~ s/$index/$value/gms;
                # For generic models, we add an img tag for images
                # and an a tag for links
                if (exists $self->{options}->{fieldsInfo}->{$value})
                {
                    # If this is an image
                    if ($self->{options}->{fieldsInfo}->{$value}->{type} eq 'image')
                    {
                        # We do it only if it is between 2 tags.
                        $line =~ s|>\$\$$value\$\$<|><img src="\$\$$value\$\$"/><|;
                    }
                    # If this is the item URL
                    elsif ($value eq $self->{model}->{commonFields}->{url})
                    {
                        # We do it only if it is between 2 tags.
                        $line =~ s|>\$\$$value\$\$<|><a href="\$\$$value\$\$"/>\$\$$self->{model}->{commonFields}->{title}\$\$</a><|;
                    }
                }
                $string .= $line;
            }
            $model =~ s/(\n?)\s*\[LOOP$loopNumber\s+values=$values\s+idx=$index(\s+filter=$filter)?\].*?\[\/LOOP$loopNumber\]/$1$string/gms;
        }
        $model =~ s/TITLE_FIELD/$self->{model}->{commonFields}->{title}/eg;
        $model =~ s/COVER_FIELD/$self->{model}->{commonFields}->{cover}/eg;

        $model =~ m{
            \[HEADER\]\n?(.*?)\n?\[\/HEADER\].*?
            \[ITEM\]\n?(.*?)\n?\[\/ITEM\].*?
            \[FOOTER\]\n?(.*?)\n?\[\/FOOTER\].*?
            \[POST\]\n?(.*?)\n?\[\/POST\]
        }xms;
        $self->{header} = $1;
        $self->{item} = $2;
        $self->{footer} = $3;
        $self->{post} = $4;
        return 1;
	}

    sub getHeader
    {
        my ($self, $total) = @_;
	
        my $result = $self->{header};

        $self->{total} = $total;
        $result =~ s/\$\$PAGETITLE\$\$/$self->{options}->{title}/g;
        $result =~ s/\$\$TOTALNUMBER\$\$/$total/g;
        $result =~ s/\$\$ITEMS\$\$/$self->{model}->getDisplayedItems/eg;

        #Search form
        $result =~ s/\$\$FORM_INPUT\$\$/$self->getLang->{InputTitle}/eg;
        $result =~ s/\$\$FORM_SEARCH1\$\$/$self->getLang->{SearchType1}/eg;
        $result =~ s/\$\$FORM_SEARCH2\$\$/$self->getLang->{SearchType2}/eg;
        $result =~ s/\$\$FORM_SEARCHBUTTON\$\$/$self->getLang->{SearchButton}/eg;
        $result =~ s/\$\$FORM_SEARCHTITLE\$\$/$self->getLang->{SearchTitle}/eg;
        $result =~ s/\$\$FORM_ALLBUTTON\$\$/$self->getLang->{AllButton}/eg;
        $result =~ s/\$\$FORM_ALLTITLE\$\$/$self->getLang->{AllTitle}/eg;
        $result =~ s/\$\$FORM_EXPAND\$\$/$self->getLang->{Expand}/eg;
        $result =~ s/\$\$FORM_EXPANDTITLE\$\$/$self->getLang->{ExpandTitle}/eg;
        $result =~ s/\$\$FORM_COLLAPSE\$\$/$self->getLang->{Collapse}/eg;
        $result =~ s/\$\$FORM_COLLAPSETITLE\$\$/$self->getLang->{CollapseTitle}/eg;

        #Labels
        $result =~ s/\$\$([a-zA-Z0-9_]*)_LABEL\$\$/$self->{model}->getDisplayedLabel($1)/eg;

        return $result."\n";
    }

    sub getFooter
    {
        my ($self, $item) = @_;
 
        my $total = $self->{total};
        my $result = $self->{footer};
        $result =~ s/\$\$PAGETITLE\$\$/$self->{options}->{title}/g;
        $result =~ s/\$\$TOTALNUMBER\$\$/$total/g;
        $result =~ s/\$\$GENERATOR_NOTE\$\$/$self->getLang->{Note}/eg;
        $result =~ s/\$\$BORROWED_ITEMS\$\$/$self->{options}->{lang}->{BorrowedTitle}/g;

        return $result."\n";
    }

    sub getItem
    {
        my ($self, $item, $idx) = @_;
        my $total = $self->{total};
        my $result = $self->{item};

        #Separator
        $result =~ s/\$\$SEPARATOR\$\$/$self->{options}->{lang}->{Separator}/g;

        #Labels that need a special process
        $result =~ s/\$\$URL_LABEL\$\$/$self->{options}->{lang}->{PanelWeb}/g;

        #Other labels
        $result =~ s/\$\$([a-zA-Z0-9_]*)_LABEL\$\$/$self->{model}->getDisplayedLabel($1)/eg;

        #Fields that need a special process
        $result =~ s/\$\$HEIGHT_PIC\$\$/$self->{options}->{imgHeight}/g;
        my $url = $item->{$self->{model}->{commonFields}->{url}} || '#';
        $result =~ s/\$\$URL\$\$/$url/g;

        #Borrower
        my $borrowerField = $self->{model}->{commonFields}->{borrower}->{name};
        my $tmpBorrower = $item->{$borrowerField};
        my $borrowerFlag = 1;
        my $borrowerYesNo = $self->getLang->{Borrowed};
        my $borrowerOrEmpty = $tmpBorrower;
        if (!$tmpBorrower || ($tmpBorrower eq 'none'))
        {
            $tmpBorrower = $self->{options}->{lang}->{PanelNobody};
            $borrowerFlag = 0;
            $borrowerYesNo = $self->getLang->{NotBorrowed};
            $borrowerOrEmpty = '';
        }
        elsif ($tmpBorrower eq 'unknown')
        {
            $tmpBorrower = $self->{options}->{lang}->{PanelUnknown};
        }
        $result =~ s/\$\$borrower\$\$/$tmpBorrower/g;
        $result =~ s/\$\$borrower_OREMPTY\$\$/$borrowerOrEmpty/g;
        $result =~ s/\$\$borrower_FLAG\$\$/$borrowerFlag/g;
        $result =~ s/\$\$borrower_YESNO\$\$/$borrowerYesNo/g;

        $result =~ s/\$\$IDX\$\$/$idx/g;
        $result =~ s/\$\$TOP\$\$/$self->getLang->{Top}/eg;
        $result =~ s/\$\$BOTTOM\$\$/$self->getLang->{Bottom}/eg;
        $result =~ s/\$\$TOTALNUMBER\$\$/$total/g;

        # Stock labels
        $result =~ s/\$\$(gtk-[^\$]*)\$\$/$self->getStockLabel($1)/eg;

        #Multiple list displayed as a table
        $result =~ s/\$\$([a-zA-Z0-9_]*)_TABLE\$\$/$self->transformData($item, $1, 1)/eg;

        #Other fields
        #$result =~ s/\$\$([A-Z_]*)\$\$/$item->{lc $1}/eg;
        $result =~ s/\$\$([a-zA-Z0-9_]*)\$\$/$self->transformData($item, $1, 0)/eg;
        return $result."\n";
    }

    sub postProcess
    {
        my ($self, $headerRef, $bodyRef) = @_;

        #Variables to be used in POST section
        my $header = $$headerRef;
        my $body = $$bodyRef;
        my @items = @{$self->{sortedArray}};

        eval $self->{post};
        print "Errors with HTML template in POST:\n  $@\n" if $@;

        $$headerRef = $header;
        $$bodyRef = $body;
    }

    sub getEndInfo
    {
        my $self = shift;
        
        if ($self->{errors})
        {
            return ($self->{errors}, 'error');
        }
        
        my $message = '';
        
        if ($self->{options}->{open})
        {
            $self->{options}->{parent}->launch($self->{fileName}, 'url');
        }
        else
        {
            $message = $self->getLang->{InfoFile}.$self->{fileName};
            $message .= '

'.$self->getLang->{InfoDir}.$self->{dirName}
                if $self->{options}->{withPictures};
        }
            
        return $message;
    }
}

1;
