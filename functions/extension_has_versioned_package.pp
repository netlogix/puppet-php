# this function returns, if a php extension package exists in a versioned name
function php::extension_has_versioned_package(String $php_extension_name) >> Boolean {

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

	if (!php::custom_sources_exist() and member($plain_package_names, "php-${php_extension_name}")) {
		false
	} else {
		true
	}
}
