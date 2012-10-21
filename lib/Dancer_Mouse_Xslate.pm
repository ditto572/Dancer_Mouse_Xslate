package Dancer_Mouse_Xslate;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
	    template 'index';
};

get '/hello/:name' => sub {
    return "Why, hello there " . param('name');
};

get '/bugs/' => sub {
	    my $xml = XML::Simple->new;
		    my $data = $xml->XMLin($filename);

			    my $count = 0;
				    my $list = "";
					    foreach my $case (@{$data->{cases}->{case}}) {
							        $list .= "<li><a href='http://bugs.movabletype.org/default.asp?$case->{ixBug}'>$case->{ixBug}</a> $case->{dtOpened}  : " . encode_entities($case->{sTitle}) . "</li>";
									        $count++;
											    }
						    template 'bugs' => {title => 'Cases in Iliad', filename => $filename, count => $count, list => $list};
							    
};

true;
