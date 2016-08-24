class acme::params {
  $package_manage    = false
  $package_name      = 'acme.sh'
  $package_ensure    = 'latest'
  $repo_manage       = false
  $repo_location     = ''
  $repo_trusted      = false
  $user              = ''
  $group             = ''
  $working_dir       = '/usr/share/acme.sh'
  $issue_command     = "acme.sh --home $home --issue -d $::fqdn --dns dns_lexicon --debug 2 >> $userhome/renew.log 2>&1"
  $userhome          = "/home/$user"
  $home              = "$userhome/.acme.sh"
  $pip_home          = "$userhome/pip"
  $certhome          = "$userhome/certs"
  $cert              = "$certhome/$::fqdn/fullchain.cer"
}
