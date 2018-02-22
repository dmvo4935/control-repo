class role::sql_server {

  #This role would be made of all the profiles that need to be included to make a database server work
  #All roles should include the base profile
#  include profile::base

   include profile::domain_member
   #include profile::sql_server_install
   include profile::sql_server_setup

#   exec {'setting DNS Suffix':
#     command      => 'Set-DnsClientGlobalSetting -SuffixSearchList ("mydomain.local")',
#     provider     => powershell,
#     }
#   include profile::cluster_node
 
     reboot {'dsc_reboot':
     message => 'DSC has requested a reboot',
     when    => 'pending',
     }   
}
