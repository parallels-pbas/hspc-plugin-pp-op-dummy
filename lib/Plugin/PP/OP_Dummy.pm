## Copyright (C) 1999-2012 Parallels IP Holdings GmbH and its affiliates.
## All rights reserved.
##
package HSPC::Plugin::PP::OP_Dummy;

use strict;
use HSPC::PluginToolkit::HTMLTemplate qw(parse_template);
use HSPC::PluginToolkit::General qw(string argparam get_help_url);

use constant TESTMODE_TYPES_TXT => { 
	1 => string('always_approve'),
	2 => string('always_decline'),
	3 => string('always_authcall'),
	4 => string('always_fraud'),
};

sub view_form {
	my $class = shift;
	my %h    = (
		config => undef,
		@_
	);
	my $config = $h{config};
	my $html;

	$html = parse_template(
				path => __PACKAGE__,
				name => 'op_dummy_view.tmpl',
				data => { testmode => &TESTMODE_TYPES_TXT->{$config->{testmode}},}
		);

	return $html;
}

sub edit_form{
	my $class = shift;
	my %h    = (
		config  => undef,
		@_
	);
	my $html;
	my $config = $h{config};
	
	my %tmpl_args = (
		testmode => $config->{testmode},
		values   => \{%{&TESTMODE_TYPES_TXT}},
	);

	$html = parse_template(
				path => __PACKAGE__,
				name => 'op_dummy_edit.tmpl',
				data => \%tmpl_args
			);

	return $html;
}

sub collect_data{
	my $class = shift;
	my %h    = (
		config  => undef,
		@_
	);
	my $config = $h{config};
	
	$config->{testmode} = argparam('testmode');

	return $config;
}

sub get_help_page {
	my $class = shift;
	my %h    = (
		action  => undef,
		language  => undef,
		@_
	);

	my $action   = $h{action};
	my $language = $h{language};

	my $html = parse_template(
		path => __PACKAGE__ . '::' . uc($language),
		name => "dummydirect_$action.html",
		data => {
			about_url =>
			  get_help_url( action => 'about', language => $language, )
		},
	);

	return $html;
}

1;