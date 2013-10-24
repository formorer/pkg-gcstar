package GCPlugins::GCbooks::GCSaraiva;

###################################################
#
#  Plugin for a brazilian bookstore named "Saraiva".
#  Code written by Guilherme "nirev" Nogueira.
#  guilherme at nirev dot org
#
###################################################

use strict;
use utf8;

use GCPlugins::GCbooks::GCbooksCommon;

{
    package GCPlugins::GCbooks::GCPluginSaraiva;

    use base qw(GCPlugins::GCbooks::GCbooksPluginsBase);
    use URI::Escape;

    sub start
    {
        my ($self, $tagname, $attr, $attrseq, $origtext) = @_;
	
        $self->{inside}->{$tagname}++;

        if ($self->{parsingList})
        {
            if (($tagname eq 'div') && ($attr->{class} eq 'hsliceLista'))
            {
                $self->{isResult} = 1;
                $self->{linkCount} = 0;
                $self->{itemIdx}++;
            }
            if (($tagname eq 'span') && ($attr->{class} eq 'entry-title'))
            {
                $self->{isTitle} = 1;
            }
            if (($tagname eq 'h2') && ($attr->{class} eq 'titulo_autor'))
            {
                $self->{isAuthor} = 1;
            }
            if (($tagname eq 'a') && $self->{isResult} && $self->{linkCount} == 0 )
            {
                $self->{itemsList}[$self->{itemIdx}]->{url} = $attr->{href};
                $self->{linkCount}++;
            }
            elsif (($tagname eq 'div') && ($attr->{class} eq 'entry-content'))
            {
                $self->{isResult} = 0;
            }
        }
        else
        {
            if (($tagname eq 'img') && ($attr->{id} eq 'imgProd'))
            {
                my $imgid = $attr->{src};
                $imgid =~ s/(.)*pro_id=//;
                $imgid =~ s/&.*$//;
                $self->{curInfo}->{cover} = 'http://www.livrariasaraiva.com.br/imagem/imagem.dll?tam=2&pro_id='.$imgid;
            }
            elsif (($tagname eq 'div') && ($attr->{id} eq 'aba1'))
            {
                $self->{isDescription} = 1;
            }
            elsif (($tagname eq 'div') && ($attr->{id} eq 'aba2'))
            {
                $self->{divInfo} = 1;
            }
            elsif (($tagname eq 'div') && ($attr->{id} eq 'produtosAbasMenus'))
            {
                $self->{divInfo} = 0;
            }
            elsif (($tagname eq 'div') && ($attr->{id} eq 'tituloprod'))
            {
                $self->{isTitle} = 1;
            }
            elsif (($tagname eq 'a') && ($attr->{href} eq 'javascript:PesquisaAutor();'))
            {
                $self->{isAuthor} = 1;
            }
            elsif (($tagname eq 'a') && ($attr->{href} eq 'javascript:PesquisaMarca();'))
            {
                $self->{isPublisher} = 1;
            }
            elsif (($tagname eq 'font'))
            {
                $self->{isAnalyse} = 1;
            }
            elsif (($tagname eq 'b') && $self->{divInfo} == 1)
            {
                $self->{isAnalyse} = 1;
            }
        }
    }

    sub end
    {
		my ($self, $tagname) = @_;

        $self->{inside}->{$tagname}--;

    }

    sub text
    {
        my ($self, $origtext) = @_;

        if ($self->{parsingList})
        {
            if ($self->{isTitle})
            {
                my $texto = $origtext;
                $self->{itemsList}[$self->{itemIdx}]->{title} = $texto;
                $self->{isTitle} = 0;
            }
            if ($self->{isAuthor})
            {
                my $texto = $origtext;
                $texto =~ s/<br>//;
                my @dados = split(' / ', $texto);
                $self->{itemsList}[$self->{itemIdx}]->{authors} = $dados[0];
                $self->{isAuthor} = 0;
            }
        }
       	else
        {
            if ($self->{isAuthor})
            {
                my @authors = split(';', $origtext);
                my $authors = '';
                my $tam = @authors;
                my $count = 0;
                for($count = 0; $count < $tam; $count++)
                {
                    $authors[$count] =~ s/^\s*//gi;
                    $authors[$count] =~ s/\s*$//gi;
                    my @names = split(', ', $authors[$count]);
                    $authors .= ',' if ($count);
                    $authors .= $names[1].' '.$names[0];

                }
                $self->{curInfo}->{authors} = $authors;
                $self->{isAuthor} = 0;
            }
            elsif ($self->{isPublisher})
            {
                $self->{curInfo}->{publisher} = $origtext;
                $self->{isPublisher} = 0;
            }
            elsif ($self->{isTitle})
            {
                $self->{curInfo}->{title} = $origtext;
                $self->{isTitle} = 0;
            }
            elsif ($self->{isDescription})
            {
                $self->{curInfo}->{description} =  $origtext;
                $self->{curInfo}->{description} =~ s/^\s*//;
                $self->{curInfo}->{description} =~ s/\s+/ /;
                $self->{isDescription} = 0;
            }
            elsif ($self->{isAnalyse})
            {
                $self->{isISBN} = 1 if ($origtext =~ m/I\.S\.B\.N/i);
                $self->{isFormat} = 1 if ($origtext =~ m/Acabamento/i);
                $self->{isPublication} = 1 if ($origtext =~ m/Edição/i);
                $self->{isPage} = 1 if ($origtext =~ m/Número de Paginas/i);
                $self->{isAnalyse} = 0 ;
            }
            elsif ($self->{isISBN})
            {
                $self->{curInfo}->{isbn} = $origtext;
                $self->{isISBN} = 0;
            }
            elsif ($self->{isFormat})
            {
                $self->{curInfo}->{format} = $origtext;
                $self->{isFormat} = 0;
            }
            elsif ($self->{isPublication})
            {
                $self->{curInfo}->{publication} = $origtext;
                $self->{isPublication} = 0;
            }
            elsif ($self->{isPage})
            {
                $self->{curInfo}->{pages} = $origtext;
                $self->{isPage} = 0;
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
            edition => 0,
            serie => 0,
        };

        $self->{isTitle} = 0;
        $self->{isAuthor} = 0;
        $self->{isAnalyse} = 0;
        $self->{isPublisher} = 0;
        $self->{isPublication} = 0;
        $self->{isPage} = 0;
        $self->{isISBN} = 0;
        $self->{isFormat} = 0;
        $self->{isDescription} = 0;
        $self->{isResult} = 0;
        $self->{linkCount} = 0;
        $self->{divInfo} = 0;

        return $self;
    }

    sub preProcess
    {
        my ($self, $html) = @_;

        if ($self->{parsingList})
        {
            my $inicio_res = index($html,'<div id="esquerdaPesquisa" style="display:none;">esquerdaPesquisa</div>');
            if ( $inicio_res >= 0 )
            {
               $html = substr($html, $inicio_res);
            }
            my $fim_res = index($html,'<div id="direitaPesquisa" style="display:none;">direitaPesquisa</div>');
            if ( $fim_res >= 0 )
            {
               $html = substr($html, 0, $fim_res);
            }
            $html = '' if ($inicio_res < 0);
        }
        else
        {
    
        }

        return $html;
    }
    
    sub getSearchUrl
    {
		my ($self, $word) = @_;

        $word =~ s|\s+|\+|;

        if ($self->{searchField} eq 'isbn')
        {
            return "http://www.livrariasaraiva.com.br/pesquisaweb/pesquisaweb.dll/pesquisa?ORDEMN2=E&ESTRUTN1=0301&PALAVRASN1=".$word;
        }
        else
        {
            return "http://www.livrariasaraiva.com.br/pesquisaweb/pesquisaweb.dll/pesquisa?ORDEMN2=E&ESTRUTN1=0301&PALAVRASN1=".$word;
        }
    }
    
    sub getItemUrl
    {
		my ($self, $url) = @_;

        return "http://www.livrariasaraiva.com.br".$url;
    }

    sub getName
    {
        return "Saraiva";
    }
    
    sub getCharset
    {
        my $self = shift;
        return "ISO-8859-1";
    }

    sub getAuthor
    {
        return 'nirev';
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
