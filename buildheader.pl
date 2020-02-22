#!/usr/bin/perl -w
# originally written by Vomit (c) June 2008
# updates by Serge van Ginderachter

my $abstractfile = shift @ARGV;
my $copyrightsfile = shift @ARGV;
my $authorsfile = shift @ARGV;
my $editorsfile = shift @ARGV;
my $contributorsfile = shift @ARGV;
my $reviewersfile = shift @ARGV;
my $publisherfile = shift @ARGV;
my $pubdate = shift @ARGV;
my $year = shift @ARGV;
my $releaseinfo = shift @ARGV;
my $teacher = shift @ARGV;

# Parse config files

open COPYR,"<$copyrightsfile" or die "Can't open copyrights $copyrightsfile";
while(<COPYR>){
    chomp;
	next if /^#/;
	@COPYRIGHT=split /,/;
	next unless scalar(@COPYRIGHT)==2;
	push @COPYRIGHTS,{
		firstname=>$COPYRIGHT[0],
		lastname=>$COPYRIGHT[1],
	};
}
close COPYR;

open AUTH,"<$authorsfile" or die "Can't open authors $authorsfile";
while(<AUTH>){
    chomp;
	next if /^#/;
	@AUTHOR=split /,/;
	next unless scalar(@AUTHOR)==4;
	push @AUTHORS,{
		firstname=>$AUTHOR[0],
		lastname=>$AUTHOR[1],
		email=>$AUTHOR[2],
		http=>$AUTHOR[3]
	};
}
close AUTH;

if (open EDIT,"<$editorsfile") {
	while(<EDIT>){
	    chomp;
		next if /^#/;
		@EDITOR=split /,/;
		next unless scalar(@EDITOR)==5;
		push @EDITORS,{
			firstname=>$EDITOR[0],
			lastname=>$EDITOR[1],
			email=>$EDITOR[2],
			emailcomment=>$EDITOR[3],
			http=>$EDITOR[4]
		};
	}
	close EDIT;
}

open CONTR,"<$contributorsfile" or die "Can't open authors $contributorsfile";
while(<CONTR>){
    chomp;
	next if /^#/;
	@CONTRIBUTOR=split /,/;
	next unless scalar(@CONTRIBUTOR)==4;
	push @CONTRIBUTORS,{
		firstname=>$CONTRIBUTOR[0],
		lastname=>$CONTRIBUTOR[1],
		email=>$CONTRIBUTOR[2],
		http=>$CONTRIBUTOR[3]
	};
}
close CONTR;

open REVW,"<$reviewersfile" or die "Can't open authors $reviewersfile";
while(<REVW>){
    chomp;
	next if /^#/;
	@REVIEWER=split /,/;
	next unless scalar(@REVIEWER)==4;
	push @REVIEWERS,{
		firstname=>$REVIEWER[0],
		lastname=>$REVIEWER[1],
		email=>$REVIEWER[2],
		http=>$REVIEWER[3]
	};
}
close REVW;

open PUBF,"<$publisherfile" or die "Can't open publisher $publisherfile";
while(<PUBF>){
	chomp;
	next if /^#/;
	@PUBLISHER=split /;/;
	next unless scalar(@PUBLISHER)==2;
	$publishername=$PUBLISHER[0];
	$publisheraddress=$PUBLISHER[1];
	last;
}
close PUBF;

print "<authorgroup>\n";
if ($teacher) {
		print "<author>\n";
		print "<firstname></firstname>\n";
		print "<surname>$teacher</surname>\n";
		print "</author>\n";
	}
else {
	foreach $author (@AUTHORS) {
		print "<author>\n";
		print "<firstname>$author->{firstname}</firstname>\n";
		print "<surname>$author->{lastname}</surname>\n";
		print "</author>\n";
	}
}
foreach $editor (@EDITORS) {
	print "<editor>\n";
	print "<firstname>$editor->{firstname}</firstname>\n";
	print "<surname>$editor->{lastname}</surname>\n";
	print "</editor>\n";
}
print "</authorgroup>\n";

if ($publishername && $publisheraddress) {
	print "<publisher>\n";
	print "<publishername>$publishername</publishername>\n";
	print "<address>$publisheraddress</address>\n";
	print "</publisher>\n";
}

# Start output header content.

print "<pubdate>$pubdate</pubdate>\n";
print "<releaseinfo>$releaseinfo</releaseinfo>\n";

open ABSTR,"<$abstractfile" or die "Can't open abstract $abstractfile";
while(<ABSTR>) {
	if(/AUTHORSCONTACT/) {
		$contacts = "<itemizedlist>\n";
		foreach $author (@AUTHORS) {
			$contacts .= "<listitem><para>$author->{firstname} $author->{lastname}: ";
			$contacts .= join(", ",($author->{email},$author->{http}));
			$contacts .= "</para></listitem>\n";
		}
		$contacts .= "</itemizedlist>\n";
		s/AUTHORSCONTACT/$contacts/;
		
	}
	if(/EDITORSCONTACT/) {
		$contacts = "<itemizedlist>\n";
		foreach $editor (@EDITORS) {
			$contacts .= "<listitem><para>$editor->{firstname} $editor->{lastname}: ";
			$contacts .= "$editor->{email}$editor->{emailcomment}";
			$contacts .= ", ";
			$contacts .= "$editor->{http}";
			$contacts .= "</para></listitem>\n";
		}
		$contacts .= "</itemizedlist>\n";
		s/EDITORSCONTACT/$contacts/;
		
	}

	s/YEAR/$year/;

	if(/\[COPYRIGHTS\]/) {
		foreach $copyright (@COPYRIGHTS) {
			push @copyrights, "$copyright->{firstname} $copyright->{lastname}";
		}
		$copyrights=join(", ",@copyrights);
		s/\[COPYRIGHTS\]/$copyrights/;
	}

	if(/\[AUTHORS\]/) {
		foreach $author (@AUTHORS) {
			push @authors, "$author->{firstname} $author->{lastname}";
		}
		$authors=join(", ",@authors);
		s/\[AUTHORS\]/$authors/;
	}

	if(/CONTRIBUTORS/) {
		$contributors = "<itemizedlist>\n";
		foreach $contributor (@CONTRIBUTORS) {
			$contributors .= "<listitem><para>$contributor->{firstname} $contributor->{lastname}: ";
			$contributors .= join(", ",($contributor->{email},$contributor->{http}));
			$contributors .= "</para></listitem>\n";
		}
		$contributors .= "</itemizedlist>\n";
		s/CONTRIBUTORS/$contributors/;
	}		

	if(/REVIEWERS/) {
		$reviewers = "<itemizedlist>\n";
		foreach $reviewer (@REVIEWERS) {
			$reviewers .= "<listitem><para>$reviewer->{firstname} $reviewer->{lastname}: ";
			$reviewers .= join(", ",($reviewer->{email},$reviewer->{http}));
			$reviewers .= "</para></listitem>\n";
		}
		$reviewers .= "</itemizedlist>\n";
		s/REVIEWERS/$reviewers/;
	}

	if(/PUBLISHER/) {
		if ($publishername && $publisheraddress) {
			s/\[PUBLISHER\]/$publishername, $publisheraddress/;
		}
	}
	print;
	
}
