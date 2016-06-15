# Private Class
class acme::config(
  $certhome          = "$userhome/certs",
  $home              = "$userhome/.acme.sh",
  $pip_bin           = "$pip_home/bin",
) inherits acme {

  validate_absolute_path($certhome)
  validate_absolute_path($home)
  

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
    owner         => $user,
    group         => $group,
  } ->
  exec { "acme-install":
    cwd     => $working_dir,
    command => "acme.sh --install --accountemail $accountemail --certhome $certhome --home $home && acme.sh --uninstallcronjob",
    path    => [ $working_dir, $pip_bin, '/bin', '/usr/bin',  ],
    user    => $user,
    creates => $home,
    require => User[$user],
  }

  exec { "acme-issue":
    cwd          => $userhome,
    environment  => $environment,
    command      => "acme.sh --home $home --issue -d $::fqdn -d sales.$::fqdn --dns dns_lexicon --debug 2 >> $userhome/renew.log 2>&1",
    user         => $user,
    path         => [$home, $pip_bin, '/bin', '/usr/bin' ],
    creates      => "$certhome/$::fqdn",
    require      => Exec['acme-install'],
  }
  
  cron { 'Renew SSL Cert':
    ensure       => present,
    environment  => "MAILTO=$accountemail",
    command      => "$home/acme.sh --cron --home $home >> $userhome/renew.log 2>&1",
    hour         => "4",
    minute       => "35",
    user         => $user,
    require      => Exec['acme-issue'],
  }

}
