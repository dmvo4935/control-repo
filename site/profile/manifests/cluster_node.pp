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

  # Dsc_xclusterquorum <<||>>
   dsc_xclusterquorum {'Connect witness': 
        dsc_resource    => "\\10.0.10.7\witness",
        dsc_psdscrunascredential  => {
           'user'     => 'mydomain.local\administrator',
           'password' => 'Supersecret#123'
        },
        dsc_issingleinstance  => 'Yes',
        dsc_type              => 'NodeAndFileShareMajority',
   }

}
