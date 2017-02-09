# == Class: acme
#

class acme (
  $package_manage    = $acme::params::package_manage,
  $repo_manage		 = $acme::params::repo_manage,
  $repo_location     = $acme::params::repo_location,
  $repo_trusted      = $acme::params::repo_trusted,
  $package_ensure    = $acme::params::package_ensure,
  $package_name      = $acme::params::package_name,
  $working_dir       = $acme::params::working_dir,
  $accountemail      = $acme::params::accountemail,
  $user              = $acme::params::user,
  $group             = $acme::params::group,
  $home              = $acme::params::home,
  $dns_environment   = $acme::params::dns_environment,
) inherits acme::params {
  validate_bool($package_manage)
  validate_string($repo_location)
  validate_bool($repo_trusted)
  validate_string($package_ensure)
  validate_string($package_name)
  validate_string($issue_command)
  validate_absolute_path($working_dir)
  validate_string($accountemail)
  validate_string($user)
  validate_string($group)
  validate_absolute_path($home)
  validate_absolute_path($userhome)
  validate_absolute_path($pip_home)
  validate_absolute_path($cert)
  validate_array($dns_environment)
  
  if $package_manage {
    if $repo_manage {
      apt::source { $package_name:
      location        => "$repo_location",
        release         => 'trusty',
        repos           => 'main',
        allow_unsigned  => $repo_trusted,
      }
    }
  package { $package_name:
    ensure   => $package_ensure,
    notify   => Exec['acme-install'],
  }
  Class['apt::update'] -> Package[$package_name]

  }
  
  include acme::config

}
