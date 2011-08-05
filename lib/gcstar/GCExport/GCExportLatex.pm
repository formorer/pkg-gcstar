package GCExport::GCExportLatex;
use utf8;

use strict;

use GCExport::GCExportBase;

{
    package GCExport::GCExporterLatex;
    
    use base qw(GCExport::GCExportBaseClass);
    
    sub new {
        my $proto = shift;
        my $class = ref($proto) || $proto;
        my $self  = $class->SUPER::new();
        
        bless ($self, $class);
        return $self;
    }
    
    sub getName {
        my $self = shift;
        return "Latex";
    }
    
    sub getOptions {
        my $self = shift;
	return [
		{
		    name => 'one',
		    type => 'yesno',
		    label => 'Export One Media',
		    default => '0',
		},
		{
		    name => 'disc',
		    type => 'number',
		    label => '# of Media',
		    default => '1',
		    min => '0',
		    max => '10000',
		},
		];
        
    }
    
    sub wantsFieldsSelection {
        return 0;
    }
    
    sub wantsImagesSelection {
        return 0;
    }
    
    sub needsUTF8 {
        return 1;
    }
    
    sub preProcess {
        my $self =  shift;
        return 1;
    }
    
    sub transformValue {
        my ($self, $value, $field) = @_;
        
        if ($field) {
            $value = $self->SUPER::transformValue($value, $field);
        }
        $value =~ s/,+$//;
        $value =~ s/\n|\r//g;
        $value =~ s/<br\/>/ /g;
        $value =~ s/\^/\\^{}/g;
        $value =~ s/\&/\\\&/g;
        $value =~ s/\"/\'\'/g;
        return $value;
    }
    
    sub getHeader {
        my ($self, $number) = @_;
        my $result = '';
        $result = "\\documentclass[a4paper]{article}
\\usepackage{ucs}
\\usepackage[utf8]{inputenc}
\\usepackage[russian]{babel}
\\usepackage{geometry}
\\geometry{a4paper,top=1cm,bottom=1cm,left=1cm,right=1cm}
\\pagestyle{empty}
\\linespread{0.6}
\\sloppy

\\newcommand{\\dvd}[2]{
\\framebox[12cm]{
\\begin{tabular}{p{0pt}\@{}p{11.9cm}}
\\rule[-6cm]{0pt}{11.7cm}&\\begin{minipage}{11.7cm}
{\\bf DVD #1}
\\begin{itemize}
\\setlength{\\parskip}{-3pt}
#2
\\end{itemize}\\vspace{-3pt}
\\end{minipage}
\\end{tabular}}}

\\begin{document}
\\footnotesize
";
        $result .= "\\dvd{$self->{options}->{disc}}{\n"
            if $self->{options}->{one};
        return $result;
    }

    sub getItem {
        my ($self, $item, $number) = @_;
        my $result;
        return '' if ($self->{options}->{one} &&
                  $item->{number} ne $self->{options}->{disc});
        $result .= '\item {\bf ' . $self->transformValue ($item->{title}, "title") . "}";
        $result .= ' / ' . $self->transformValue ($item->{original}, 'original') if $item->{original};
        $result .= " ($item->{date})" if $item->{date};
        # one line for russian cartoons
        if ($self->transformValue ($item->{genre}, 'genre') =~
            m/Мультфильм/) {
            $result .= ' м/ф';
        } elsif ($item->{genre} || $item->{director} || 
            $item->{audio} || $item->{time}) {
            $result .= "\\\\\n\\begin{tabular}{ll}\n";
            $result .= $self->getLocal('genre') . ': & ' . 
            $self->transformValue ($item->{genre}, 'genre') . '\\\\'
                if $item->{genre};
            $result .= $self->getLocal('director') . ": & $item->{director}\\\\"
            if $item->{director};
            my $audio = $self->transformValue ($item->{audio}, 'audio')
                if $item->{audio};
            $audio =~ s/\([\w\ ]+\)//g;
            $audio =~ s/\([\w\ ]+\)//g;
            $audio =~ s/\ ,/,/g;
            $audio =~ s/\s+$//g;
            $result .= $self->getLocal('audio') . ": & $audio" if length ($audio) > 0;
            $result .= "; " . $self->transformValue ($item->{subt}, 'subt') .
            ' (' . $self->getLocal('subt') . ')'
                if $item->{subt};
            $result .= '\\\\';
            $result .= $self->getLocal('time') . ": & $item->{time} мин.\\\\" if $item->{time};
            $result .= $self->getLocal('country') . ": & $item->{country}" if $item->{country};
            $result .= "\n\\end{tabular}\n";
        }
        # don't include information about media # 0
        if ((!$self->{options}->{one}) && $item->{number} != 0) {
            $self->{expdata}->{$item->{number}} .= $result;
            $self->{expdata}->{all} .= $self->{expdata}->{all} ? ',' . $item->{number} : $item->{number} if $self->{expdata}->{all} !~ m/$item->{number}/;
            return '';
        } elsif ($self->{options}->{one}) {
            return $result;
        }
        return '';
    }
    
    sub getFooter {
        my $self = shift;
        my $result = '';
        if ($self->{options}->{one}) {
            $result = "\n}\n\\end{document}\n";
        } else {
        my @data = split (/,/, $self->{expdata}->{all});
        foreach my $key (sort @data) {
            $result .= "\n\n\\dvd{$key}{\n$self->{expdata}->{$key}}";
        }
        $result .= "\n\\end{document}\n";
	}
        return $result;
    }

    sub getLocal {
        my ($self, $name) = @_;
    # some abbreviations for russian language
        if ($self->{options}->{lang}->{LangName} eq "Russian") {
            return "Реж." if $name eq "director";
            return "Звук" if $name eq "audio";
            return "Время" if $name eq "time";
            return "суб." if $name eq "subt";
            return $self->{model}->getDisplayedLabel($name);
        } else {
            return $self->{model}->getDisplayedLabel($name);
        }
    }

    sub getModels {
        return ['GCfilms'];
    }

    sub postProcess {
        my ($self, $header, $body) = @_;
    }

    sub getEndInfo {
        my $self = shift;
        my $message;
        
        return $message;
    }
}

1;
