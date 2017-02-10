# == Class: acme
#

class acme (
  Optional[Boolean] $package_manage,
  Optional[Boolean] $repo_manage,
  Optional[Boolean] $repo_trusted,
  Optional[String] $repo_location,
  Optional[String] $package_ensure,
  Optional[String] $package_name,
  Optional[String] $accountemail,
  Optional[String] $user,
  Optional[String] $group,
  Optional[String] $issue_command,
  Optional[String] $install_command,
  Optional[Stdlib::Absolutepath] $pip_home,
  Optional[Stdlib::Absolutepath] $pip_bin,
  Optional[Stdlib::Absolutepath] $acme_home,
  Optional[Stdlib::Absolutepath] $user_home,
  Optional[Stdlib::Absolutepath] $cert_home,
  Optional[Stdlib::Absolutepath] $cert,
  Optional[Stdlib::Absolutepath] $working_dir,
  Optional[Array[String]] $dns_environment,
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
