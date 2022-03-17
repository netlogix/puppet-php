# this function normalizes php extension package names depending on several factors
function php::normalize_php_ext(String $php_extension_name, Optional[String] $php_version = undef) >> String {

	$real_php_version = $php_version ? {
		undef => pick(lookup('php::params::php_version'), $facts['php_version'][0,3]),
		default => $php_version
	}

	if (php::extension_has_versioned_package($php_extension_name)) {
		$real_package_name = "php${real_php_version}-${php_extension_name}"
	} else {
		$real_package_name = "php-${php_extension_name}"
	}

	$real_package_name
}
