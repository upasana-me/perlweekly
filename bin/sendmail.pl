#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long qw(GetOptions);
use MIME::Lite::HTML;
use MIME::Lite;
use Cwd qw(abs_path cwd);

my %opt;
GetOptions(\%opt,
	'to=s',
	'issue=i',
	'subject=s',
) or die;
die "Usage: $0 --to mail\@address.com  --issue N --subject SUBJECT\n" if not $opt{to} or not $opt{issue};

my $from = 'Gabor Szabo <gabor@szabgab.com>';

my $subject = 'The current Perl Weekly News - Issue #' . $opt{issue};
if ($opt{subject}) {
	$subject .= " - $opt{subject}";
}

my $host = 'szabgab.com';
my %content;
$content{html} = qx{$^X bin/generate.pl mail $opt{issue}};
$content{text} = qx{$^X bin/generate.pl text $opt{issue}};

my $msg = MIME::Lite->new(
	From     => $from,
	To       => $opt{to},
	Type     => 'multipart/alternative',
	Subject  => $subject,
	#Data     => $text,
);

my %type = (
	text => 'text/plain',
	html => 'text/html',
);

foreach my $t (qw(text html)) {
	my $att = MIME::Lite->new(
		Type     => 'text',
		Data     => $content{$t},
		Encoding => 'quoted-printable',
	);
	$att->attr("content-type" => "$type{$t}; charset=UTF-8");
	$att->replace("X-Mailer" => "");
	$att->attr('mime-version' => '');
	$att->attr('Content-Disposition' => '');

	$msg->attach($att);
}


$msg->send;

