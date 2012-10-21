package Dancer_Mouse_Xslate;
use Dancer ':syntax';

our $VERSION = '0.1';

my $data_file = './notice.txt';

get '/hello/:name' => sub {
    return "Why, hello there " . param('name');
};

get '/' => sub {
    my $self = shift;
		    
    # Open data file(Create file if not exist)
    my $mode = -f $data_file ? '<' : '+>';
    open my $data_fh, $mode, $data_file
        or die "Cannot open $data_file: $!";

    # Read data
    my $entry_infos = [];
    while (my $line = <$data_fh>){
        chomp $line;
        my @record = split /\t/, $line;
 
	    my $entry_info = {};
	    $entry_info->{datetime} = $record[0];
	    $entry_info->{title}    = $record[1];
	    $entry_info->{message}  = $record[2];

        push @$entry_infos, $entry_info;
    }

    # Close
    close $data_fh;

    # Reverse data order
    @$entry_infos = reverse @$entry_infos;

    # Render index page
#	$self->render(entry_infos => $entry_infos);
    template 'login', {entry_infos => $entry_infos};

};

true;
