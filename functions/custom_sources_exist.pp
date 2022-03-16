# this function checks, if custom php sources from a list are defined
function php::custom_sources_exist(Array $sources = pick(lookup('custom_php_sources'), [])) >> Boolean {

	$sources_filtered = $sources.filter |$source| {
		(defined(Apt::Source[$source]) and Apt::Source[$source]['ensure'] != 'absent') or (defined(Apt::Ppa[$source]) and Apt::Ppa[$source]['ensure'] != 'absent')
	}
	$custom_source_defined = length($sources_filtered) > 0

	$has_custom_source = $custom_source ? {
		true => true,
		default => $custom_source_defined
	}

	$has_custom_source
}
