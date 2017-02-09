class acme::params {
  $userhome          = "/home/$user"
  $acme_home         = "$userhome/.acme.sh"
  $pip_home          = "$userhome/pip"
  $pip_bin           = "$pip_home/bin"
  $package_manage    = false
  $package_name      = 'acme.sh'
  $package_ensure    = 'latest'
  $repo_manage       = false
  $repo_location     = ''
  $repo_trusted      = false
  $user              = 'acme'
  $group             = 'acme'
  $accountemail      = 'email@provider.com'
  $certhome          = "$userhome/certs"
  $cert              = "$certhome/$::fqdn/fullchain.cer"
  $working_dir       = '/usr/share/acme.sh'
  $issue_command     = "acme.sh --home $home --issue -d $::fqdn --dns dns_lexicon --debug 2 >> $userhome/renew.log 2>&1"
  $dns_environment   = {
    'PROVIDER'                     => 'dnsmadeeasy',
    'LEXICON_DNSMADEEASY_USERNAME' => '',
    'LEXICON_DNSMADEEASY_TOKEN'    => ''
  }
}
