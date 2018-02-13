class profile::sql_server_setup {

$sql_source = '\\\\10.0.10.7\\SQLInstallation'

 dsc_windowsfeature {'.NET35':
  dsc_ensure => 'present',
  dsc_name   => 'Net-Framework-Core',
} -> 

 dsc_xsqlserversetup {'Install SQL Server': 
  
dsc_action              => 'Install',
dsc_installsqldatadir	=> 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data',
dsc_installsharedwowdir	=> 'C:\Program Files (x86)\Microsoft SQL Server',
dsc_sqlcollation	=> 'SQL_Latin1_General_CP1_CI_AS',
dsc_sourcecredential    => {
    'user'      =>  'mydomain.local\\administrator',
    'password'  =>  'Supersecret#123'
    },
dsc_sqltempdblogdir	=> 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data',
dsc_sqluserdbdir	=> 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data',
dsc_agtsvcaccount	=> {
    'user'      =>  'mydomain.local\\administrator',
    'password'  =>  'Supersecret#123'
    },
dsc_installshareddir	=> 'C:\Program Files (x86)\Microsoft SQL Server',
dsc_sqltempdbdir	=> 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data',
dsc_instancename        => 'MSSQLSERVER',
dsc_setupcredential     =>  {
    'user'      =>  'mydomain.local\\administrator',
    'password'  =>  'Supersecret#123'
    },	
dsc_sqlbackupdir	=> 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup',
dsc_sqluserdblogdir	=> 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data',
dsc_sqlsysadminaccounts	 => 'mydomain.local\\administrator',
dsc_instancedir	        => 'C:\Program Files\Microsoft SQL Server',
dsc_sqlsvcaccount	=> {
    'user'      =>  'mydomain.local\\administrator',
    'password'  =>  'Supersecret#123'
     },
dsc_features             => 'SQLENGINE',
dsc_sourcepath	         => $sql_source,

} -> 

  dsc_xsqlservernetwork {'Enable networking':
  ensure               => 'present',	
#  dsc_psdscrunascredential	PsDscRunAsCredential
  dsc_instancename     => 'MSSQLSERVER',
  dsc_protocolname     => 'tcp',
  dsc_isenabled	       => 'True',
#  dsc_tcpdynamicports  => '',
  dsc_tcpport          => '1433',
  dsc_restartservice   => 'True',
}
  
  reboot {'dsc_reboot':
     message => 'DSC has requested a reboot',
     when    => 'pending',
     }
}
