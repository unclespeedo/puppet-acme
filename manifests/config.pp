# Private Class
class acme::config(
  $certhome          = "$userhome/certs",
  $home              = "$userhome/.acme.sh",
) inherits acme {

  validate_absolute_path($certhome)
  validate_absolute_path($home)

  exec { "acme-install":
    cwd     => $working_dir,
    command => "acme.sh --install --accountemail $accountemail --certhome $certhome --home $home && acme.sh --uninstallcronjob",
    path    => [ $working_dir, '/bin', '/usr/bin' ],
    user    => $user,
    creates => $home,
    require => User[$user],
  }

  exec { "acme-issue":
    cwd     => $userhome,
    command => "acme.sh --home $home --issue -d $::fqdn -d sales.$::fqdn --debug 2 >> $userhome/renew.log 2>&1",
    user    => $user,
    path    => [$home, '/bin', '/usr/bin'],
    creates => "$certhome/$::fqdn",
    require => Exec['acme-install'],
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
