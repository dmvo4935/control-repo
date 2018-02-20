class profile::alwayson_config ($role) {

dsc_xsqlserveralwaysonservice {'Enable AlwaysOnService':
  dsc_sqlserver	          => "${::fqdn}",
#  dsc_restarttimeout	RestartTimeout - The length of time, in seconds, to wait for the service to restart. Default is 120 seconds.
  dsc_psdscrunascredential  => { 'user' => 'mydomain\administrator', 'password'  => 'Supersecret#123' },
  dsc_ensure	          => 'Present', 
  dsc_sqlinstancename       => 'MSSQLSERVER'
 } -> 

dsc_xsqlserverendpoint {'Create endpoint':
   dsc_sqlserver            => "${::fqdn}",
   dsc_psdscrunascredential =>	{ 'user' => 'mydomain\administrator', 'password'  => 'Supersecret#123' },
   dsc_ipaddress            => 	"${::ipaddress}", 
   dsc_ensure	            =>  'Present',
   dsc_sqlinstancename	    => 'MSSQLSERVER',
   dsc_endpointname 	    => "${::fqdn}",
   dsc_port                 => '5022'
} -> 

dsc_xsqlserverlogin {'Create login for cluster user':
   dsc_sqlserver	                => "${::fqdn}",
   dsc_psdscrunascredential	        => { 'user' => 'mydomain\administrator', 'password'  => 'Supersecret#123' },
   dsc_name	                        => 'NT SERVICE\ClusSvc',
   dsc_ensure	                        => 'Present',
   dsc_sqlinstancename	                => 'MSSQLSERVER', 
   dsc_logintype	                => 'WindowsUser',
   } ->

dsc_xsqlserverpermission {'Set Permissions to ClusSvc and SYSTEM logins':
   dsc_nodename	            => "${::fqdn}",
   dsc_psdscrunascredential => { 'user' => 'mydomain\administrator', 'password'  => 'Supersecret#123' },
   dsc_instancename	    => 'MSSQLSERVER',
  dsc_ensure	            => 'Present',
  dsc_principal	            => [ 'NT SERVICE\ClusSvc', 'NT AUTHORITY\SYSTEM' ],
  dsc_permission	    => [ 'AlterAnyAvailabilityGroup', 'ViewServerState' ],
  } ->

if ($role=='primary')
   {
    dsc_xsqlserveralwaysonavailabilitygroup {'Create primary AG':
     dsc_availabilitymode               => 'SynchronousCommit',
     dsc_connectionmodeinsecondaryrole  => 'AllowAllConnections',
     dsc_failureconditionlevel	       => 'OnServerDown',
     dsc_failovermode                   => 'Automatic',
     dsc_connectionmodeinprimaryrole    => 'AllowAllConnections',
     dsc_sqlserver	               => "${::fqdn}",
     dsc_psdscrunascredential           => { 'user' => 'mydomain\administrator', 'password'  => 'Supersecret#123' },
     dsc_name	                       => 'DefaultAG',
     dsc_endpointhostname	       => "${::fqdn}",
     dsc_sqlinstancename	               => "MSSQLSERVER",
     dsc_ensure	                       => 'Present'
    }->
   
   dsc_xsqlserveravailabilitygrouplistener {'Create AG listener':
     dsc_nodename	     => "${::fqdn}",
     dsc_availabilitygroup   => "DefaultAG",
     dsc_psdscrunascredential => { 'user' => 'mydomain\administrator', 'password'  => 'Supersecret#123' },
     dsc_name	              => 'DefaultAGListener',
     dsc_instancename	      => 'MSSQLSERVER',
     dsc_ipaddress	      => '10.0.10.61/255.255.255.192',
     dsc_ensure	              => 'Present',
     dsc_port                 => '1433'
    }
   } 
   else {
   dsc_xsqlserveralwaysonavailabilitygroupreplica {'Create secondary replica':
    dsc_availabilitymode               => 'SynchronousCommit',
    dsc_connectionmodeinsecondaryrole  => 'AllowAllConnections',
   # dsc_sqlservernetname	       => '' SqlServerNetName - Output the NetName property from the SQL Server object. Used by Get-TargetResource
    dsc_failovermode	               => 'Automatic',
    dsc_primaryreplicasqlinstancename  => 'MSSQLSERVER',
    dsc_connectionmodeinprimaryrole    => 'AllowAllConnections',
    dsc_sqlserver	               => "${::fqdn}", 
    dsc_psdscrunascredential	       =>  { 'user' => 'mydomain\administrator', 'password'  => 'Supersecret#123' },
    dsc_name	                       => 'DefaultAGReplica',
    dsc_endpointhostname	       => "${::fqdn}", 
    dsc_sqlinstancename	               => 'MSSQLSERVER',
    dsc_ensure	                       => 'Present',
    dsc_availabilitygroupname          => 'DefaultAG'
    } 
   }

}
