## Copyright (C) 1999-2012 Parallels IP Holdings GmbH and its affiliates.
## All rights reserved.
##
package HSPC::MT::Plugin::PP::OP_Dummy;

use strict;
use HSPC::PluginToolkit::General qw(string);

sub get_title {
	my $class = shift;
	
	return string('dummy_naming');
}

sub get_supported_payment_method_types{
	my $self = shift;
	
	return [
		'M',    ## Mastercard
		'V',    ## Visa
		'A',    ## Americanexpress
		'C',    ## Dinersclub
		'E',    ## Enroute
		'B',    ## Dinersclub_carteblanche
		'D',    ## Discover
		'J',    ## Jcb
		'W',    ## Switch
		'S',    ## Solo
		'T',    ## Delta
		'O',    ## Optima
		'L',    ## Visa Electron
	];
}

sub process_preauthorize{
	my $self = shift;
	my %h    = (
		config  => undef,
		@_
	);

	return $self->_process_transaction(%h, type => 'preauthorize');
}

sub process_capture{
	my $self = shift;
	my %h    = (
		config  => undef,
		@_
	);

	return $self->_process_transaction(%h, type => 'capture');

}

sub process_sale {
	my $self = shift;
	my %h    = (
		config  => undef,
		@_
	);

	return $self->_process_transaction(%h, type => 'sale');
}

sub process_preauthorize_void{
	my $self = shift;
	my %h    = (
		config  => undef,
		@_
	);

	return $self->_process_transaction(%h, type => 'preauthorize_void');
}

sub process_capture_void{
	my $self = shift;
	my %h    = (
		config  => undef,
		@_
	);

	return $self->_process_transaction(%h, type => 'capture_void');
}

sub process_credit{
	my $self = shift;
	my %h    = (
		config  => undef,
		@_
	);

	return $self->_process_transaction(%h, type => 'credit');
}

sub _process_transaction {
	my $self = shift;
	my %h    = (
		config  => undef,
		@_
	);
	my $config = $h{config};
	
	my $result;
	my $message;
	my $mode_string;

	if ($config->{testmode} == 1) {
		$result      = 'APPROVED';
		$message     = '';
		$mode_string = 'Always Approve';
	} elsif ($config->{testmode} == 2) {
		$result      = 'DECLINED';
		$message     = 'Dummy credit payment failed (test mode setting)';
		$mode_string = 'Always Decline';
	} elsif ($config->{testmode} == 4) {
		$result      = 'FRAUD';
		$message     = 'Dummy credit payment fraud (test mode setting)';
		$mode_string = 'Always Fraud';
	} elsif ($config->{testmode} == 3) {
		if ( $h{type} =~ /preauthorize|sale/) {
			$result      = 'AUTHCALL';
			$message     = 'Dummy credit payment AuthCall (test mode setting)';
			$mode_string = 'Always AuthCall';
		} else {
			$result      = 'APPROVED';
			$message     = '';
			$mode_string = 'Approve (test mode set to AuthCall)';
		}
	}
	my $ret= {
		STATUS      => $result,
		TEXT		=> {
			customer_message => $message,
			vendor_message   => $message,
		},
		TRANSACTION_DETAILS  => {
				ccp_auth_code     => 'DUMMY',
				ccp_approval_code => 'DUMMY',
				testmode          => $mode_string,
			},
	};
	return $ret;
}

sub get_currencies_supported{
	return [
				'ADP', # Andorran Peseta
				'AED', # UAE Dirham
				'AFA', # Afghani
				'ALL', # Lek
				'AMD', # Armenian Dram
				'ANG', # Antillian Guilder
				'AON', # New Kwanza
				'AOR', # Kwanza Reajustado
				'ARS', # Argentine Peso
				'ATS', # Schilling
				'AUD', # Australian Dollar
				'AWG', # Aruban Guilder
				'AZM', # Azerbaijanian Manat
				'BAM', # Convertible Marks
				'BBD', # Barbados Dollar
				'BDT', # Taka
				'BEF', # Belgian Franc
				'BGL', # Lev
				'BGN', # Bulgarian LEV
				'BHD', # Bahraini Dinar
				'BIF', # Burundi Franc
				'BMD', # Bermudian Dollar
				'BND', # Brunei Dollar
				'BRL', # Brazilian Real
				'BSD', # Bahamian Dollar
				'BTN', # Ngultrum
				'BWP', # Pula
				'BYR', # Belarussian Ruble
				'BZD', # Belize Dollar
				'CAD', # Canadian Dollar
				'CDF', # Franc Congolais
				'CHF', # Swiss Franc
				'CLF', # Unidades de fomento
				'CLP', # Chilean Peso
				'CNY', # Yuan Renminbi
				'COP', # Colombian Peso
				'CRC', # Costa Rican Colon
				'CUP', # Cuban Peso
				'CVE', # Cape Verde Escudo
				'CYP', # Cyprus Pound
				'CZK', # Czech Koruna
				'DEM', # Deutsche Mark
				'DJF', # Djibouti Franc
				'DKK', # Danish Krone
				'DOP', # Dominican Peso
				'DZD', # Algerian Dinar
				'ECS', # Sucre
				'ECV', # Unidad de Valor Constante (UVC)
				'EEK', # Kroon
				'EGP', # Egyptian Pound
				'ERN', # Nakfa
				'ESP', # Spanish Peseta
				'ETB', # Ethiopian Birr
				'EUR', # Euro
				'FIM', # Markka
				'FJD', # Fiji Dollar
				'FKP', # Pound
				'FRF', # French Franc
				'GBP', # Pound Sterling
				'GEL', # Lari
				'GHC', # Cedi
				'GIP', # Gibraltar Pound
				'GMD', # Dalasi
				'GNF', # Guinea Franc
				'GRD', # Drachma
				'GTQ', # Quetzal
				'GWP', # Guinea-Bissau Peso
				'GYD', # Guyana Dollar
				'HKD', # Hong Kong Dollar
				'HNL', # Lempira
				'HRK', # Kuna
				'HTG', # Gourde
				'HUF', # Forint
				'IDR', # Rupiah
				'IEP', # Irish Pound
				'ILS', # New Israeli Sheqel
				'INR', # Indian Rupee
				'IQD', # Iraqi Dinar
				'IRR', # Iranian Rial
				'ISK', # Iceland Krona
				'ITL', # Italian Lira
				'JMD', # Jamaican Dollar
				'JOD', # Jordanian Dinar
				'JPY', # Yen
				'KES', # Kenyan Shilling
				'KGS', # Som
				'KHR', # Riel
				'KMF', # Comoro Franc
				'KPW', # North Korean Won
				'KRW', # Won
				'KWD', # Kuwaiti Dinar
				'KYD', # Cayman Islands Dollar
				'KZT', # Tenge
				'LAK', # Kip
				'LBP', # Lebanese Pound
				'LKR', # Sri Lanka Rupee
				'LRD', # Liberian Dollar
				'LSL', # Loti
				'LTL', # Lithuanian Litas
				'LUF', # Luxembourg Franc
				'LVL', # Latvian Lats
				'LYD', # Libyan Dinar
				'MAD', # Moroccan Dirham
				'MDL', # Moldovan Leu
				'MGF', # Malagasy Franc
				'MKD', # Denar
				'MMK', # Kyat
				'MNT', # Tugrik
				'MOP', # Pataca
				'MRO', # Ouguiya
				'MTL', # Maltese Lira
				'MUR', # Mauritius Rupee
				'MVR', # Rufiyaa
				'MWK', # Kwacha
				'MXN', # Mexican Peso
				'MXV', # Mexican Unidad de Inversion (UDI)
				'MYR', # Malaysian Ringgit
				'MZM', # Metical
				'NAD', # Namibia Dollar
				'NGN', # Naira
				'NIO', # Cordoba Oro
				'NLG', # Netherlands Guilder
				'NOK', # Norwegian Krone
				'NPR', # Nepalese Rupee
				'NZD', # New Zealand Dollar
				'OMR', # Rial Omani
				'PAB', # Balboa
				'PEN', # Nuevo Sol
				'PGK', # Kina
				'PHP', # Philippine Peso
				'PKR', # Pakistan Rupee
				'PLN', # Zloty
				'PTE', # Portuguese Escudo
				'PYG', # Guarani
				'QAR', # Qatari Rial
				'ROL', # Leu
				'RUB', # Russian Ruble
				'RUR', # Russian Ruble
				'RWF', # Rwanda Franc
				'SAR', # Saudi Riyal
				'SBD', # Solomon Islands Dollar
				'SCR', # Seychelles Rupee
				'SDD', # Sudanese Dinar
				'SEK', # Swedish Krona
				'SGD', # Singapore Dollar
				'SHP', # St Helena Pound
				'SIT', # Tolar
				'SKK', # Slovak Koruna
				'SLL', # Leone
				'SOS', # Somali Shilling
				'SRG', # Surinam Guilder
				'STD', # Dobra
				'SVC', # El Salvador Colon
				'SYP', # Syrian Pound
				'SZL', # Lilangeni
				'THB', # Baht
				'TJR', # Tajik Ruble (old)
				'TJS', # Somoni
				'TMM', # Manat
				'TND', # Tunisian Dinar
				'TOP', # Pa'anga
				'TPE', # Timor Escudo
				'TRY', # Turkish Lira
				'TTD', # Trinidad and Tobago Dollar
				'TWD', # New Taiwan Dollar
				'TZS', # Tanzanian Shilling
				'UAH', # Hryvnia
				'UGX', # Uganda Shilling
				'USD', # US Dollar
				'USN', # (Next day)
				'USS', # (Same day)
				'UYU', # Peso Uruguayo
				'UZS', # Uzbekistan Sum
				'VEB', # Bolivar
				'VND', # Dong
				'VUV', # Vatu
				'WST', # Tala
				'XAF', # CFA Franc BEAC
				'XAG', # Silver
				'XAU', # Gold Bond Markets Units
				'XBA', # European Composite Unit (EURCO)
				'XBB', # European Monetary Unit (E.M.U.-6)
				'XBC', # European Unit of Account 9 (E.U.A.- 9)
				'XBD', # European Unit of Account 17 (E.U.A.- 17)
				'XCD', # East Caribbean Dollar
				'XDR', # SDR
				'XOF', # CFA Franc BCEAO
				'XPD', # Palladium
				'XPF', # CFP Franc
				'XPT', # Platinum
				'XTS', # Codes specifically reserved for testing purposes
				'YER', # Yemeni Rial
				'YUM', # New Dinar
				'ZAL', # (financial Rand)
				'ZAR', # Rand
				'ZMK', # Kwacha
				'ZRN', # New Zaire
				'ZWD', # Zimbabwe Dollar
		];
}


1;