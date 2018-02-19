class profile::cluster_node {

$clustering_features = ['Failover-Clustering', 'RSAT-Clustering']

windowsfeature { $clustering_features:
  ensure => 'present',
  installsubfeatures => true,
  } ->

  dsc_xcluster { 'DefaultCluster': 
  dsc_domainadministratorcredential  => {
    'user'     => 'mydomain.local\\administrator',
    'password' => 'Supersecret#123'
  },
#dsc_psdscrunascredential	PsDscRunAsCredential
    dsc_name   => 'defaultcluster',
    dsc_staticipaddress => '10.0.10.62/26',
    }

#str_addr = regexstr("$::ipaddress")

notify {'testing regexstr function':
    name => regexstr($::ipaddress)
    }

@@file_line {'adding cluster address to hosts file':
path                   => 'C:\\windows\\system32\\drivers\\etc\\hosts',
ensure                 => 'present',
#match                  => '^10\.0\.10\.52.*$',
match                  => regexstr($::ipaddress),
multiple               => 'false',
replace                => 'false',
append_on_no_match     => 'true',
provider               => ruby,
line                   => "${::ipaddress} defaultcluster defaultcluster.mydomain.local"
}

  # Dsc_xclusterquorum <<||>>
   dsc_xclusterquorum {'Connect witness': 
        dsc_resource    => "\\\\10.0.10.7\\witness",
        dsc_psdscrunascredential  => {
           'user'     => 'mydomain.local\administrator',
           'password' => 'Supersecret#123'
        },
        dsc_issingleinstance  => 'Yes',
        dsc_type              => 'NodeAndFileShareMajority',
   }

}
