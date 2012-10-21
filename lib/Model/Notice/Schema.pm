package Model::Notice::Schema;
use Teng::Schema::Declare;
table {
	    name 'notice';
		    pk 'id';
			    columns qw( datetime title message );
};
1;
