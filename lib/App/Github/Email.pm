package App::Github::Email;

use LWP::UserAgent;
use Getopt::Long qw(GetOptions);
use Email::Address;
use List::MoreUtils qw(uniq);
#PODNAME: App-Github-Email
#VERSION

my $name;

GetOptions( "name=s" => \$name ) or die("Error");

if (not defined $name)
{
	die "Error. Username is not defined. Please try again with: 'github-email -n username'.\n";
}

my $ua = LWP::UserAgent->new;
my $json_get = $ua->get("https://api.github.com/users/$name/events/public");

if ( $json_get->is_success )
{
    my $raw_json    = $json_get->decoded_content;
    my @addresses   = Email::Address->parse($raw_json);
    my @unique_addr = uniq @addresses;

    for my $address (@unique_addr)
	{
        if ( $address ne 'git@github.com')
		{
            say $address;
        }
    }
}

else
{
    die "User is not exist\n";
}

__END__

=head1 SYNOPSIS

	github-email --name <Github username>

	github-email --name faraco
	github-email --n faraco 

=cut
