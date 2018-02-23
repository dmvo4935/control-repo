## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
#https://docs.puppet.com/pe/2015.3/release_notes.html#filebucket-resource-no-longer-created-by-default
File { backup => false }

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }

}

node 'ec2amaz-pcdm8f8.mydomain.local' {
    windowsfeature { 'Web-WebServer':
    ensure             => present,
    installsubfeatures => true,
   } 
   
   $iis_features =  ['Web-Server','Web-Scripting-Tools']
    iis_feature { $iis_features:
    ensure => present,
    notify => Iis_site['Default Web Site']
  } 
   
   iis_site { 'Default Web Site':
     ensure           => 'started',
     applicationpool  => 'DefaultAppPool',
     physicalpath     => 'C:\inetpub\wwwroot',
     }
}

node 'ec2amaz-2i3051d.mydomain.local' {
   
   $adfeatures = ['AD-Domain-Services', 'RSAT-AD-Tools', 'RSAT-ADDS']
   
   windowsfeature { $adfeatures:
   ensure             => present,
   installsubfeatures => true,
   notify             => Dsc_xaddomain['xADDomain'],
   }
   
   dsc_xaddomain {'xADDomain':
   dsc_domainname => 'mydomain.local',
   dsc_safemodeadministratorpassword => {
    'user' => 'administrator',
    'password' => 'Supersecret#123',
    },
    dsc_domainadministratorcredential => {
     'user' => 'administrator',
     'password' => 'Supersecret#123',  
     },
   }
  
   reboot {'dsc_reboot':
     message => 'DSC has requested a reboot',
     when    => 'pending',
     }

   @@exec {'Configuring Dns Client':
   #command  => 'Import-module ADDSDeployment',
   command   => "Set-DnsClientServerAddress * -ServerAddresses (\"$::ipaddress\")",
   provider  => powershell,
   tag       => 'primary_dc',
            }

#   notify {"(\"$::ipaddress\")" : }   

    class { 'profile::mount_iso': } ->
  
    class { 'profile::create_share': }

#    $witness_address="\\\\$::fqdn\\Witness\\"

    @@dsc_xclusterquorum {'Connect witness': 
        dsc_resource    => "\\\\${::ipaddress}\\witness",
        dsc_psdscrunascredential  => {
           'user'     => 'mydomain.local\administrator',
           'password' => 'Supersecret#123'
        },
        dsc_issingleinstance  => 'Yes',
        dsc_type              => 'NodeAndFileShareMajority',
        require               => Dsc_xcluster['DefaultCluster']
   }

   include chocolatey  
   
  chocolateysource {'chocolatey':
   ensure   => present,
   location => 'https://chocolatey.org/api/v2',
   priority => 1,
   }

   package {'awscli':
   ensure   => 'installed',
   provider => chocolatey,
   notify   => Class['profile::mount_iso'],
  }

   package {'sql-server-management-studio':
     ensure   => 'installed',
     provider => chocolatey,
     require => Chocolateysource['chocolatey'],
   }
    
}

node 'ec2amaz-p5g3loa.mydomain.local' {
  $adfeatures = ['AD-Domain-Services', 'RSAT-AD-Tools']
  
  windowsfeature {'RSAT-ADDS':
   ensure             => present,
   installsubfeatures => true,
   }
  
  windowsfeature {'AD-Domain-Services':
   ensure             => present,
   installsubfeatures => true,
  # notify             => Exec['Set-DnsClientServerAddress * -ServerAddresses ("10.0.10.7")'],
   } ->
   
  # exec {'Set-DnsClientServerAddress * -ServerAddresses ("10.0.10.7")': 
 #  provider  => powershell,
 #  notify    => Dsc_xaddomaincontroller['xADDomainController'],
 #  } 
   
  Exec <<| tag == 'primary_dc' |>> ->  
  
  dsc_xaddomaincontroller {'xADDomainController':
   dsc_domainname => 'mydomain.local',
   dsc_safemodeadministratorpassword => {
    'user' => 'administrator',
    'password' => 'Supersecret#123',
    },
    dsc_domainadministratorcredential => {
     'user' => 'mydomain.local\administrator',
     'password' => 'Supersecret#123',  
     },
   }
  
   reboot {'dsc_reboot':
     message => 'DSC has requested a reboot',
     when    => 'pending',
     }
  
}

node 'ec2amaz-u2tvmiu.mydomain.local' {
  
  class { 'role::sql_server':}

  include profile::cluster_node_secondary

  class { 'profile::alwayson_config': role => 'secondary' }
}

node 'ec2amaz-nejlvpg.mydomain.local' {

  class { 'role::sql_server': }
  
  include profile::cluster_node

  class { 'profile::alwayson_config': role => 'primary' }
}
