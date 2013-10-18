# == Class: php::fpm
#
# Install and configure mod_php for fpm
#
# === Parameters
#
# [*ensure*]
#   The ensure of the fpm package to install
#   Could be "latest", "installed" or a pinned verison
#
# [*package*]
#   The package name for fpm package
#   For debian it's php5-fpm
#
# [*provider*]
#   The provider used to install php5-fpm
#   Could be "pecl", "apt" or any other OS package provider
#
# [*inifile*]
#   The path to the ini php5-fpm ini file
#
# [*settings*]
#   Hash with 'set' nested hash of key => value
#   set changes to agues when applied to *inifile*
#
# === Variables
#
# No variables
#
# === Examples
#
#  include php::fpm
#
# === Authors
#
# Christian "Jippi" Winther <jippignu@gmail.com>
#
# === Copyright
#
# Copyright 2012-2013 Christian "Jippi" Winther, unless otherwise noted.
#
class php::fpm(
  $ensure                      = $php::fpm::params::ensure,
  $package                     = $php::fpm::params::package,
  $provider                    = $php::fpm::params::provider,
  $inifile                     = $php::fpm::params::inifile,
  $settings                    = $php::fpm::params::settings,
  $log_level                   = $php::fpm::params::log_level,
  $emergency_restart_threshold = $php::fpm::params::emergency_restart_threshold,
  $emergency_restart_interval  = $php::fpm::params::emergency_restart_interval,
  $process_control_timeout     = $php::fpm::params::process_control_timeout,
  $process_max                 = $php::fpm::params::process_max,
  $log_owner                   = $php::fpm::params::log_owner,
  $log_group                   = $php::fpm::params::log_group,
  $log_dir_mode                = $php::fpm::params::log_dir_mode,
  $config_template             = $php::fpm::params::config_template,
) inherits php::fpm::params {

  # Hack-ish to default to user for group too
  $log_group_final = $log_group ? {
    false   => $log_owner,
    default => $log_group,
  }

  if ( $ensure == 'absent' ) {

    package { 'php5-fpm':
      ensure => absent
    }

  } else {

    package { $package:
      ensure   => $ensure,
      provider => $provider;
    }

    php::config { 'php-fpm':
      inifile  => $inifile,
      settings => $settings
    }

    service { 'php5-fpm':
      ensure    => running,
      enable    => true,
      restart   => 'service php5-fpm reload',
      hasstatus => true,
      require   => Package[$package]
    }

    file { '/etc/php5/fpm/php-fpm.conf':
      notify  => Service['php5-fpm'],
      content => template($config_template),
      owner   => root,
      group   => root,
      mode    => '0644',
    }

  }

}
