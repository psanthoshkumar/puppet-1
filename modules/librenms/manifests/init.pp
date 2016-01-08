# puppet class to manage librenms dependencies

class librenms {
	include librenms::packages
	#include librenms::pear
	#include librenms::cron
}

class librenms::packages {
	include apache
	include php5
	include snmp

	$common_pkgs = [

		"fping",
		"git",
		"graphviz",
		"nmap",
		"php-pear",
		"rrdtool",

	]
	$deb_pkgs = [

		"imagemagick",
		"ipcalc",
		"ipmitool",
		"mtr-tiny",
		"mysql-client",
		"php5-cli",
		"php5-curl",
		"php5-gd",
		"php5-json",
		"php5-mcrypt",
		"php5-mysql",
		"php5-snmp",
		"php5-xcache",
		"php-net-ipv4",
		"php-net-ipv6",
		"python-mysqldb",
		"sipcalc",
		"snmp",
		"whois",

	]
	$centos_pkgs = [

		"ImageMagick",
		"jwhois",
		"mysql",
		"net-snmp-utils",
		"OpenIPMI-tools",
		"php-gd",
		"php-mysql",
		"php-pecl-apc",
		"php-snmp",

	]

	$ospkgs = $operatingsystem ? {
		Debian	=> $deb_pkgs,
		Ubuntu	=> $deb_pkgs,
		CentOS	=> $centos_pkgs,
	}
	package { $common_pkgs:
		ensure	=> installed,
	}
	package { $ospkgs:
		ensure	=> installed,
	}
}

class librenms::pear {
	# TODO:
	# pear config-set http_proxy http://host:port/
	# pear install Net_IPv4
	# pear install Net_IPv6
}

class librenms::install {
	# TODO:
	# install files
}

class librenms::mysql::dump {
	ulb { "librenms-mysql-dump":
		source_class	=> "librenms",
	}
	cron_job { "librenms-mysql-dump":
		interval	=> "daily",
		script		=> "#!/bin/sh
# Generated by puppet - do not edit here
/usr/local/bin/librenms-mysql-dump
",
	}
}

