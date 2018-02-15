class profile::cluster_node_secondary {

$clustering_features = ['Failover-Clustering', 'RSAT-Clustering']

windowsfeature { $clustering_features:
  ensure => 'present',
  installsubfeatures => true,
  } ->

  dsc_xwaitforcluster {'WaitForCluster': 
     dsc_retryintervalsec	=> '15',
     dsc_psdscrunascredential	=> {
          'user'       => 'mydomain\administrator',
          'password'   => 'Supersecret#123'
           },           
     dsc_name	       => 'defaultcluster',
     dsc_retrycount    => '100',
     notify            => Dsc_xcluster['DefaultCluster']
   }
  
  dsc_xcluster { 'DefaultCluster': 
  dsc_domainadministratorcredential  => {
    'user'     => 'mydomain.local\\administrator',
    'password' => 'Supersecret#123'
  },
#dsc_psdscrunascredential	PsDscRunAsCredential
    dsc_name   => 'defaultcluster',
    dsc_staticipaddress => '10.0.10.62/26',
    }

}
