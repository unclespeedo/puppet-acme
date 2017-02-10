# == Class: acme
#

class acme (
  Optional[Boolean] $package_manage,
  Optional[Boolean] $repo_manage,
  Optional[String] $repo_location,
  Optional[Boolean] $repo_trusted,
  Optional[String] $package_ensure,
  Optional[String] $package_name,
  Optional[Stdlib::Absolutepath] $working_dir,
  Optional[String] $accountemail,
  Optional[String] $user,
  Optional[String] $group,
  Optional[Stdlib::Absolutepath] $pip_home,
  Optional[Stdlib::Absolutepath] $home,
  Array[String] $dns_environment,
)  {
  
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
