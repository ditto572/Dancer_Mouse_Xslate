package Dancer_Mouse_Xslate;
use Dancer ':syntax';
use Data::Dumper;
use Model::Notice;
    
our $VERSION = '0.1';

my $data_file = './notice.txt';
my $teng = Model::Notice->new({ connect_info => [ 'dbi:SQLite:dbname=../db/notice.db' ] });

get '/' => sub {

	my $itr = $teng->search('user',{});
	  
    my @rows = $itr->all;

    while (my $row = $itr->next) {
	    
    }

    # Open data file(Create file if not exist)
    my $mode = -f $data_file ? '<' : '+>';
    open my $data_fh, $mode, $data_file
        or die "Cannot open $data_file: $!";

    # Read data
    my $entry_infos = [];
    while (my $line = <$data_fh>){
        chomp $line;
		next if $line eq '';

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
    template 'login', {entry_infos => $entry_infos};
};

post '/create' => sub {

	my $title   = params->{'title'};
    my $message = params->{'message'};

    return template, 'error', {message  => 'Please input title'}
	      unless $title;

    return template, 'error', {message => 'Please input message'}
	      unless $message;

    return template, 'error', {message => 'Title is too long'}
	      if length $title > 30;

    return template, 'error', {message => 'Message is too long'}
	      if length $message > 100;

    my ($sec, $min, $hour, $day, $month, $year) = localtime;
	    $month = $month + 1; 
	    $year = $year + 1900;

    my $datetime = sprintf("%04s/%02s/%02s %02s:%02s:%02s", 
        $year, $month, $day, $hour, $min, $sec);

	$message =~ s/\x0D\x0A|\x0D|\x0A//g;

	my $record = join("\t", $datetime, $title, $message) . "\n";

	open my $data_fh, ">>", $data_file
			      or die "Cannot open $data_file: $!";

	$record = b($record)->encode('UTF-8')->to_string;

    print $data_fh $record;

    # Close
    close $data_fh;

    # Redirect
    redirect, 'index';


};

true;
