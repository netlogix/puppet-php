# this function normalizes php extension package names depending on several factors
function php::normalize_php_ext(String $php_extension_name, Array $sources = pick(lookup('custom_php_sources'), []), Optional[String] $php_version = undef, Boolean $custom_source = false) >> String {

	$real_php_version = $php_version ? {
		undef => pick(lookup('php::params::php_version'), $facts['php_version'][0,3]),
		default => $php_version
	}

	$custom_source_defined = php::custom_sources_exist()

	$has_custom_source = $custom_source ? {
		true => true,
		default => $custom_source_defined
	}

	$has_versioned_package = php::extension_has_versioned_package($php_extension_name)

	if ($has_versioned_package) {
		$real_package_name = "php${real_php_version}-${php_extension_name}"
	} else {
		$real_package_name = "php-${php_extension_name}"
	}

	$real_package_name
}
