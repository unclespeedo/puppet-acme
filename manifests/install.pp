#
class acme::install inherits acme {

  include ::apt
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