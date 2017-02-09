class acme::params {
  $user              = 'acme'
  $group             = 'acme'
  $user_home          = "/home/$user"
  $acme_home         = "$user_home/.acme.sh"
  $pip_home          = "$user_home/pip"
  $pip_bin           = "$pip_home/bin"
  $package_manage    = false
  $package_name      = 'acme.sh'
  $package_ensure    = 'latest'
  $repo_manage       = false
  $repo_location     = ''
  $repo_trusted      = false
  $accountemail      = 'email@provider.com'
  $cert_home          = "$user_home/certs"
  $cert              = "$cert_home/$::fqdn/fullchain.cer"
  $working_dir       = '/usr/share/acme.sh'
  $issue_command     = "acme.sh --home $acme_home --issue -d $::fqdn --dns dns_lexicon --debug 2 >> $user_home/renew.log 2>&1"
  $dns_environment   = {
    'PROVIDER'                     => 'dnsmadeeasy',
    'LEXICON_DNSMADEEASY_USERNAME' => '',
    'LEXICON_DNSMADEEASY_TOKEN'    => ''
  }
}
