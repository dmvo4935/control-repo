class role::sql_server {

  #This role would be made of all the profiles that need to be included to make a database server work
  #All roles should include the base profile
#  include profile::base

   include profile::domain_member
   #include profile::sql_server_install
   include profile::sql_server_setup
   include profile::cluster_node
}
