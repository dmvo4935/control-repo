class profile::domain_member {

#exec {'Set-DnsClientServerAddress * -ServerAddresses ("10.0.10.7")':
#   provider  => powershell,
#   } ->

Exec <<| tag == 'primary_dc' |>> ->

class { 'domain_membership':
  domain       => 'mydomain.local',
  username     => 'Administrator',
  password     => 'Supersecret#123',
  join_options => '3',
}

 exec {'setting DNS Suffix':
     command      => 'Set-DnsClientGlobalSetting -SuffixSearchList ("mydomain.local")',
     provider     => powershell,
     } 

  windowsfeature {'Windows-defender-features':
     ensure  => absent,
  }

}
