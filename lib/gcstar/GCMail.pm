package GCMail;

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
use utf8;

our $muas = 0;

our %defaultMua = (
    'Evolution' => 'evolution "mailto:%t?subject=%s&body=%b"',
    'Claws Mail' => 'sylpheed-claws --compose "mailto:%t?subject=%s&body=%b"',
    'Thunderbird' => 'thunderbird -compose "mailto:%t?subject=%s&body=%b"',
);

our $mailersConfigurationFile = 'GCmailers.conf';

sub getMailers
{
    my $mailers;
    if (!$muas)
    {
        if (-f $ENV{GCS_CONFIG_HOME}."/$mailersConfigurationFile")
        {
            open MAILERS, $ENV{GCS_CONFIG_HOME}."/$mailersConfigurationFile";
            my $xmlString = do {local $/; <MAILERS>};
            close MAILERS;
            my $xs = XML::Simple->new;
            $mailers = $xs->XMLin($xmlString,
                                  ContentKey => '-content');
            $muas = $mailers->{mailer};
        }
        else
        {
            $muas = \%defaultMua;
        }
    }
    return $muas;
}

{
    package GCMailDialog;
    use base "Gtk2::Dialog";
    use Net::SMTP;
   
    sub show
    {
        my $self = shift;

        $self->SUPER::show();
        $self->show_all;
        
        if ($self->run eq 'ok')
        {
            my $mail = $self->formatMail;
            
            $self->sendMail($self->{from}->get_text, $self->{to}->get_text, $mail);
        }
        $self->hide;
    }

    sub sendMail
    {
        my ($self, $from, $to, $mail) = @_;

        $to =~ s/.*?<|>.*?//g;
        
        if ($self->{options}->mailer eq 'Sendmail')
        {
            $! = '';
            if (open(MAILER, "| sendmail -t -ba"))
            {
                print MAILER "$mail\r\n.\r\n";
                close MAILER;
            }
            else
            {
                my  $dialog = Gtk2::MessageDialog->new($self,
                        [qw/modal destroy-with-parent/],
                        'error',
                        'ok',
                        $self->{parent}->{lang}->{MailSendmailError}."\n\n$!");

                $dialog->set_position('center-on-parent');
                $dialog->run;
                $dialog->destroy;               
            }
        }
        else
        {
            my $smtp = Net::SMTP->new($self->{options}->smtp);
            if (!$smtp)
            {
                my  $dialog = Gtk2::MessageDialog->new($self,
                        [qw/modal destroy-with-parent/],
                        'error',
                        'ok',
                        $self->{parent}->{lang}->{MailSmtpError});
                  
                $dialog->set_position('center-on-parent');  
                $dialog->run;
                $dialog->destroy;
                return;
            }
            $smtp->mail($from);
            $smtp->to($to);
            $smtp->data;
            $smtp->datasend($mail);
            $smtp->dataend;
            $smtp->quit;
        }
    }
    
    sub formatMail
    {
        my $self = shift;
        
        my $mail = '';
        
        $mail .= "From: ".$self->{from}->get_text."\r\n";
        $mail .= "To: ".$self->{to}->get_text."\r\n";
        $mail .= "Subject: ".$self->{subject}->get_text."\r\n\r\n";
        
        my $buffer = $self->{mailContent}->get_buffer;
        
        $mail .= $buffer->get_text($buffer->get_start_iter, $buffer->get_end_iter, 1);
        
        $mail .= "\r\n";
    }
    
    sub new
    {
        my ($proto, $parent, $from, $to, $subject, $body) = @_;
        my $class = ref($proto) || $proto;
        (my $title = $parent->{lang}->{MailTitle}) =~ s/_//;
        my $self  = $class->SUPER::new($title,
                                       $parent,
                                       [qw/modal destroy-with-parent/],
                                       @GCDialogs::okCancelButtons
                                      );

        bless ($self, $class);
 
        $self->set_modal(1);
		$self->set_position('center');
        $self->set_default_size(400,400);

        $self->{parent} = $parent;
        $self->{options} = $parent->{options};
        my $items = $self->{parent}->{items};

        my $table = new Gtk2::Table(2,2,0);
        $table->set_row_spacings($GCUtils::margin);
        $table->set_col_spacings(0);
        $table->set_border_width($GCUtils::margin);
        
        my $labelFrom = new Gtk2::Label($parent->{lang}->{MailFrom});
        $labelFrom->set_alignment(0,0.5);
        $self->{from} = new Gtk2::Entry;
        $self->{from}->set_text($from);
        my $labelTo = new Gtk2::Label($parent->{lang}->{MailTo});
        $labelTo->set_alignment(0,0.5);
        $self->{to} = new Gtk2::Entry;
        $self->{to}->set_text($to);
        my $labelSubject = new Gtk2::Label($parent->{lang}->{MailSubject});
        $labelSubject->set_alignment(0,0.5);
        $self->{subject} = new Gtk2::Entry;
        $self->{subject}->set_text($subject);
                
        $table->attach($labelFrom, 0, 1, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($self->{from}, 1, 2, 0, 1, 'fill', 'fill', 0, 0);
        $table->attach($labelTo, 0, 1, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($self->{to}, 1, 2, 1, 2, 'fill', 'fill', 0, 0);
        $table->attach($labelSubject, 0, 1, 2, 3, 'fill', 'fill', 0, 0);
        $table->attach($self->{subject}, 1, 2, 2, 3, 'fill', 'fill', 0, 0);
       
        $self->{mailContent} = new Gtk2::TextView;
        $self->{mailContent}->set_editable(1);
        $self->{mailContent}->set_wrap_mode('word');
        $self->{mailContent}->get_buffer->set_text($body);
        my $scrollContent = new Gtk2::ScrolledWindow;
        $scrollContent->set_border_width(10);
        $scrollContent->set_shadow_type('in');
        $scrollContent->set_policy('automatic', 'automatic');
        $scrollContent->set_size_request(-1,80);
        $scrollContent->add($self->{mailContent});
                                            
        $self->vbox->pack_start($table,0,0,10);
        $self->vbox->pack_start($scrollContent,1,1,10);
 
        return $self;
    }
    
}

{
    package GCMailer;

    use URI::Escape qw(uri_escape_utf8);

    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self = {parent => $parent};
        bless ($self, $class);
        return $self;
    }

    sub sendBorrowerEmail
    {
        my ($self, $info) = @_;

        my %mail = ();
        my $options = $self->{parent}->{options};
        $mail{from} = $options->from;
        
        my @borrowers = split m/\|/, $options->borrowers;
        my @emails = split m/\|/, $options->emails;
        my $email;
        for (my $i = 0; $i < scalar(@borrowers); $i++)
        {
            $email = $emails[$i];
            last if $borrowers[$i] eq $info->{borrower};
        }
        $mail{to} = $info->{borrower}." <$email>";

        $mail{subject} = $options->subject;
        $mail{subject} =~ s/%1/$info->{borrower}/g;
        $mail{subject} =~ s/%2/"$info->{title}"/g;
        $mail{subject} =~ s/%3/$info->{lendDate}/g;

        $mail{body} = $options->template;
        $mail{body} =~ s/<br\/>/\n/g;
        $mail{body} =~ s/%1/$info->{borrower}/g;
        $mail{body} =~ s/%2/"$info->{title}"/g;
        $mail{body} =~ s/%3/$info->{lendDate}/g;
        
        $self->prepareEmailSending(\%mail);

        #$self->showMe;
    }
    
    sub prepareEmailSending
    {
        my ($self, $mail) = @_;
        if (($self->{parent}->{options}->mailer eq 'Sendmail')
         || ($self->{parent}->{options}->mailer eq 'SMTP'))
        {
            my $dialog = new GCMailDialog($self->{parent}, $mail->{from}, $mail->{to},
                                          $mail->{subject}, $mail->{body});
            $dialog->show;
        }
        else
        {
            $mail->{body} = uri_escape_utf8($mail->{body});
            my $clients = GCMail::getMailers();
            my $command = $clients->{$self->{parent}->{options}->mailer};
            $command =~ s/%f/$mail->{from}/gx;
            $command =~ s/%t/$mail->{to}/gx;
            $command =~ s/%s/$mail->{subject}/gx;
            $command =~ s/%b/$mail->{body}/gx;
            #system $command;
            $self->{parent}->launch($command, 'program', 1);
        }
    }

}

{
    package GCMailProgramsDialog;
    use base 'GCModalDialog';
    use XML::Simple;

    sub initValues
    {        
        my $self = shift;
        use locale;
    
        my $mailers = GCMail::getMailers;
        @{$self->{mailers}->{data}} = ();
        foreach (sort keys %$mailers)
        {
            my @infos = [$_, $mailers->{$_}];
            push @{$self->{mailers}->{data}}, @infos;
        }
        $self->{mailers}->select(0);
   }
    
   sub saveValues
   {
        my $self = shift;

        $muas = {};
        my $mailers;
        foreach (@{$self->{mailers}->{data}})
        {
            push @{$mailers->{mailer}}, {name => $_->[0], content => $_->[1]};
            $muas->{$_->[0]} = $_->[1];
        }
        my $xs = XML::Simple->new;
        my $xmlData = $xs->XMLout($mailers,
                                  XMLDecl => '<?xml version="1.0" encoding="UTF-8"?>',
                                  RootName => 'mailers'
                                 );
        open MAILERS, '>'.$ENV{GCS_CONFIG_HOME}."/$mailersConfigurationFile";
        print MAILERS $xmlData;
        close MAILERS;
    }
   
    sub show
    {
        my $self = shift;

        $self->initValues;
        
        $self->SUPER::show();
        $self->show_all;
        
        my $result = $self->run;
        $self->saveValues if $result eq 'ok';
        {
            $self->saveValues;
        }
        $self->hide;
        return ($result eq 'ok');
    }

    sub restoreDefault
    {
        my $self = shift;
        $muas = \%defaultMua;
        $self->initValues;
    }

    sub removeCurrent
    {
        my $self = shift;
        my @idx = $self->{mailers}->get_selected_indices;
        splice @{$self->{mailers}->{data}}, $idx[0], 1;
    }
    
    sub add
    {
        my $self = shift;
        
        my $dialog = new Gtk2::Dialog($self->{parent}->{lang}->{MailProgramsAdd},
                                                        $self,
                                                        [qw/modal destroy-with-parent/],
                                                        @GCDialogs::okCancelButtons
                                                    );
        
        my $table = new Gtk2::Table(2,2,0);
                                                    
        my $labelName = new GCLabel($self->{parent}->{lang}->{MailProgramsName});
        $table->attach($labelName, 0, 1, 0, 1, 'fill', 'fill', 5, 5);
        my $name = new Gtk2::Entry;
        $table->attach($name, 1, 2, 0, 1, 'expand', 'fill', 5, 5);
 
        my $labelEmail = new GCLabel($self->{parent}->{lang}->{MailProgramsCommand});
        $table->attach($labelEmail, 0, 1, 1, 2, 'fill', 'fill', 5, 5);
        my $email = new Gtk2::Entry;
        $table->attach($email, 1, 2, 1, 2, 'expand', 'fill', 5, 5);
       
        $dialog->vbox->pack_start($table,1,1,0);
        $dialog->vbox->show_all;
                                                    
        if ($dialog->run eq 'ok')
        {
            unshift @{$self->{mailers}->{data}}, [$name->get_text, $email->get_text];
        }
        
        $dialog->destroy;
    }
    
    sub new
    {
        my ($proto, $parent) = @_;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new($parent,
                                       $parent->{lang}->{MailProgramsTitle},
                                      );

        bless ($self, $class);
 
        #$self->set_modal(1);
		$self->set_position('center');
        $self->set_default_size(400,400);

        $self->{reverse} = 0;

        $self->{parent} = $parent;
        $self->{lang} = $parent->{lang};
        $self->{options} = $parent->{options};

        my $hbox = new Gtk2::HBox(0,0);
        
        $self->{mailers} = new Gtk2::SimpleList($parent->{lang}->{MailProgramsName} => "text",
                                                $parent->{lang}->{MailProgramsCommand} => "text");
        $self->{mailers}->set_column_editable(0, 1);
        $self->{mailers}->set_column_editable(1, 1);
        $self->{mailers}->set_rules_hint(1);

        $self->{mailers}->get_column(0)->set_sort_column_id(0);
        $self->{mailers}->get_model->set_sort_column_id(0, 'ascending');

        for my $i (0..1)
        {
            $self->{mailers}->get_column($i)->set_resizable(1);
        }
        $self->{order} = 1;
        $self->{sort} = -1;

        my $scrollPanelList = new Gtk2::ScrolledWindow;
        $scrollPanelList->set_policy ('never', 'automatic');
        $scrollPanelList->set_shadow_type('etched-in');
        $scrollPanelList->set_border_width(0);
        $scrollPanelList->add($self->{mailers});
        
        my $vboxButtons = new Gtk2::VBox(0,0);
        my $addButton = Gtk2::Button->new_from_stock('gtk-add');
        $addButton->signal_connect('clicked' => sub {
                $self->add;
            });
        my $removeButton = Gtk2::Button->new_from_stock('gtk-remove');
        $removeButton->signal_connect('clicked' => sub {
                $self->removeCurrent;
            });
            
        my $restoreButton = Gtk2::Button->new($parent->{lang}->{MailProgramsRestore});
        $restoreButton->signal_connect('clicked' => sub {
                $self->restoreDefault;
            });
            
        $vboxButtons->pack_start($addButton,0,0,$GCUtils::halfMargin);
        $vboxButtons->pack_start($removeButton,0,0,$GCUtils::halfMargin);
        $vboxButtons->pack_start($restoreButton,0,0,$GCUtils::halfMargin);

        my $instructions = new GCLabel($parent->{lang}->{MailProgramsInstructions});
        $instructions->set_padding($GCUtils::margin, $GCUtils::halfMargin);

        $hbox->pack_start($scrollPanelList,1,1,0);
        $hbox->pack_start($vboxButtons,0,0,$GCUtils::margin);
        $hbox->set_border_width($GCUtils::margin);
        $self->vbox->pack_start($hbox,1,1,0);
        $self->vbox->pack_start($instructions,0,0,0);
        
        return $self;
    }
    
}


1;
