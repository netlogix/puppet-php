# this function checks, if custom php sources from a list are defined
function php::custom_sources_exist(Array $sources = pick(lookup('custom_php_sources'), [])) >> Boolean {

	$sources_filtered = $sources.filter |$source| {
		(defined(Apt::Source[$source]) and Apt::Source[$source]['ensure'] != 'absent') or (defined(Apt::Ppa[$source]) and Apt::Ppa[$source]['ensure'] != 'absent')
	}

	length($sources_filtered) > 0
}
