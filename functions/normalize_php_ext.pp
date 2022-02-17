# this function normalizes php extension package names depending on several factors
function php::normalize_php_ext(String $php_extension_name, Array $sources = pick(lookup('custom_php_sources'), []), Optional[String] $php_version = undef, Boolean $custom_source = false) >> String {

	# These extensions have no phpX.Y-name package on plain ubuntu systems.
	# They ALWAYS depend on the php-version shipped with ubuntu.
	# When using ondrej ppa however, there are corresponding phpX.Y-name packages which must
	# be used in favor of the plain package names.
	$plain_package_names = [
		"php-amqp",
		"php-amqplib",
		"php-apcu",
		"php-apcu-bc",
		"php-date",
		"php-db",
		"php-dompdf",
		"php-ds",
		"php-fpdf",
		"php-fxsl",
		"php-gearman",
		"php-geoip",
		"php-geos",
		"php-gmagick",
		"php-gnupg",
		"php-guestfs",
		"php-igbinary",
		"php-imagick",
		"php-memcache",
		"php-memcached",
		"php-mongodb",
		"php-oauth",
		"php-parser",
		"php-pcov",
		"php-ps",
		"php-radius",
		"php-raphf",
		"php-raphf-dev",
		"php-redis",
		"php-solr",
		"php-ssh2",
		"php-tcpdf",
		"php-tideways",
		"php-tokenizer",
		"php-uuid",
		"php-validate",
		"php-xdebug",
		"php-yaml",
		"php-zmq",
	]

	$real_php_version = $php_version ? {
		undef => pick(lookup('php::params::php_version'), $facts['php_version'][0,3]),
		default => $php_version
	}

	$sources_filtered = $sources.filter |$source| {
		defined(Apt::Source[$source]) or defined(Apt::Ppa[$source])
	}
	$custom_source_defined = length($sources_filtered) > 0

	$has_custom_source = $custom_source ? {
		true => true,
		default => $custom_source_defined
	}

	if (!$has_custom_source and member($plain_package_names, "php-${php_extension_name}")) {
		$real_package_name = "php-${php_extension_name}"
	} else {
		$real_package_name = "php${real_php_version}-${php_extension_name}"
		# resources work in puppet > 4 inside functions
		package { "php-${php_extension_name}":
			ensure => 'absent',
		}
	}

	$real_package_name
}
