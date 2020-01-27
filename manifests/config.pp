# Private Class
class acme::config inherits acme {

  class { 'python':
    version    => 'system',
    pip        => 'latest',
    dev        => 'absent',
    virtualenv => 'present',
    gunicorn   => 'absent',
  }
  -> python::virtualenv { $pip_home:
    ensure   => present,
    version  => '3',
    venv_dir => $acme::pip_home,
    owner    => $acme::user,
    group    => $acme::group,
  }
  -> python::pip { 'dns-lexicon' :
    ensure     => 'present',
    pkgname    => 'dns-lexicon',
    virtualenv => $acme::pip_home,
    owner      => $acme::user,
    group      => $acme::group,
  }
  -> exec { 'acme-install':
    cwd     => $acme::working_dir,
    command => $acme::install_command,
    path    => [ $acme::working_dir, $acme::pip_bin, '/bin', '/usr/bin' ],
    user    => $acme::user,
    creates => $acme::acme_home,
    require => User[$acme::user],
  }
  file { $cert_home:
    ensure  => directory,
    owner   => $acme::user,
    mode    => '0700',
    require => Exec['acme-install'],
  }
  exec { 'acme-issue':
    cwd         => $acme::user_home,
    environment => $acme::dns_environment,
    command     => "acme.sh --home ${acme::acme_home} --issue ${acme::issue_command} >> ${acme::user_home}/renew.log 2>&1",
    user        => $acme::user,
    path        => [$acme::acme_home, $acme::pip_bin, '/bin', '/usr/bin' ],
    creates     => $acme::cert,
    require     => File[$acme::cert_home],
  }
  cron { 'Renew SSL Cert':
    ensure      => present,
    environment => "MAILTO=${acme::accountemail}",
    command     => "${acme::acme_home}/acme.sh --cron --home ${acme::acme_home} >> ${acme::user_home}/renew.log 2>&1",
    hour        => '4',
    minute      => '35',
    user        => $acme::user,
    require     => Exec['acme-install'],
  }

}
