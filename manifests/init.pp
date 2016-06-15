# == Class: acme
#


class acme (
  $package_manage    = $acme::params::package_manage,
  $repo_manage		 = $acme::params::repo_manage,
  $repo_location     = $acme::params::repo_location,
  $repo_trusted      = $acme::params::repo_trusted,
  $package_ensure    = $acme::params::package_ensure,
  $package_name      = $acme::params::package_name,
) inherits acme::params {
  validate_bool($package_manage)
  validate_string($repo_location)
  validate_bool($repo_trusted)
  validate_string($package_ensure)
  validate_string($package_name)
  
  if $package_manage {
    include acme::install
  }
}
