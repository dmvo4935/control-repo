class profile::cluster_node_secondary {

$clustering_features = ['Failover-Clustering', 'RSAT-Clustering']

windowsfeature { $clustering_features:
  ensure => 'present',
  installsubfeatures => true,
  } ->

exec {'Reset Client DNS Cache': command => 'Clear-DnsClientCache', provider => powershell } ->

file_line {'adding cluster address to hosts file':
path                   => 'C:\\windows\\system32\\drivers\\etc\\hosts',
ensure                 => 'present',
match	               => '^10\.0\.10\.52.*$',
multiple               => 'false',
replace                => 'true',
append_on_no_match     => 'true',
provider	       => ruby,
line                   => '10.0.10.52 defaultcluster defaultcluster.mydomain.local'
} ->

  dsc_xwaitforcluster {'WaitForCluster': 
     dsc_retryintervalsec	=> '15',
     dsc_psdscrunascredential	=> {
          'user'       => 'mydomain\\administrator',
          'password'   => 'Supersecret#123'
           },           
     dsc_name	       => 'defaultcluster',
     dsc_retrycount    => '100',
     notify            => Dsc_xcluster['DefaultCluster']
   }
  
  dsc_xcluster { 'DefaultCluster': 
  dsc_domainadministratorcredential  => {
    'user'     => 'mydomain\\administrator',
    'password' => 'Supersecret#123'
  },
  dsc_psdscrunascredential           => {
    'user'     => 'mydomain\\administrator',
    'password' => 'Supersecret#123'
  },
    dsc_name   => 'defaultcluster',
    dsc_staticipaddress => '10.0.10.62/26',
    }

}
