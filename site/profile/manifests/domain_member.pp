class profile::domain_member {

exec {'Set-DnsClientServerAddress * -ServerAddresses ("10.0.10.7")':
   provider  => powershell,
   } ->

class { 'domain_membership':
  domain       => 'mydomain.local',
  username     => 'Administrator',
  password     => 'Supersecret#123',
  join_options => '3',
}

}
