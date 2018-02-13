class profile::cluster_node {

windowsfeature { 'RSAT-Clustering':
  ensure => 'present',
  }
}
