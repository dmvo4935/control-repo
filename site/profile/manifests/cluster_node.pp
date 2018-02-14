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
    dsc_staticipaddress => '10.0.10.63/26',
    }

   Dsc_xclusterquorum <<||>>
}
