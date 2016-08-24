# == Class: acme
#

class acme (
  $package_manage    = $acme::params::package_manage,
  $repo_manage		 = $acme::params::repo_manage,
  $repo_location     = $acme::params::repo_location,
  $repo_trusted      = $acme::params::repo_trusted,
  $package_ensure    = $acme::params::package_ensure,
  $package_name      = $acme::params::package_name,
  $issue_command     = $acme::params::issue_command,
  $working_dir       = $acme::params::working_dir,
  $accountemail      = '',
  $user              = $acme::params::user,
  $group             = $acme::params::group,
  $home              = $acme::params::home,
  $userhome          = $acme::params::userhome,
  $environment       = '',
  $pip_home          = $acme::params::pip_home,
  $certhome          = $acme::params::certhome,
  $cert              = $acme::params::cert
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
  validate_array($environment)
  validate_absolute_path($pip_home)
  validate_absolute_path($certhome)
  validate_absolute_path($cert)
  
  if $package_manage {
    include acme::install
  }
  
  include acme::config

}
