# Private Class
class acme::config {

  class { 'python':
    version    => 'system',
    pip        => 'present',
    dev        => 'absent',
    virtualenv => 'present',
    gunicorn   => 'absent',
  } ->
  python::virtualenv { $pip_home:
    ensure       => present,
    version      => 'system',
    venv_dir     => $pip_home,
    owner        => $user,
    group        => $group,
  } ->
  python::pip { 'dns-lexicon' :
    pkgname       => 'dns-lexicon',
    virtualenv    => $pip_home,
    ensure        => '1.1.8',
    owner         => $user,
    group         => $group,
  } ->
  exec { "acme-install":
    cwd     => $working_dir,
    command => "acme.sh --install --accountemail $accountemail --certhome $certhome --home $acme_home --nocron",
    path    => [ $working_dir, $pip_bin, '/bin', '/usr/bin' ],
    user    => $user,
    creates => $acme_home,
    require => User[$user],
  }
  file { $certhome:
    ensure    => directory,
    owner     => $user,
    mode      => '700',
    require   => Exec['acme-install'],
  }
  exec { "acme-issue":
    cwd          => $userhome,
    environment  => $environment,
    command      => $issue_command,
    user         => $user,
    path         => [$acme_home, $pip_bin, '/bin', '/usr/bin' ],
    creates      => $cert,
    require      => File[$certhome],
  }
  
  cron { 'Renew SSL Cert':
    ensure       => present,
    environment  => "MAILTO=$accountemail",
    command      => "$acme_home/acme.sh --cron --home $acme_home >> $userhome/renew.log 2>&1",
    hour         => "4",
    minute       => "35",
    user         => $user,
    require      => Exec['acme-install'],
  }

}
