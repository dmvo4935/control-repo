class profile::sql_server_install {

$sql_source = '\\10.0.10.7\H$'

sqlserver_instance{ 'MSSQLSERVER':
  source                  => $sql_source,
  features                => ['SQL'],
  install_switches        => {
    'TCPENABLED'          => 1,
    'SQLBACKUPDIR'        => 'C:\\MSSQLSERVER\\backupdir',
    'SQLTEMPDBDIR'        => 'C:\\MSSQLSERVER\\tempdbdir',
    'INSTALLSQLDATADIR'   => 'C:\\MSSQLSERVER\\datadir',
    'INSTANCEDIR'         => 'C:\\Program Files\\Microsoft SQL Server',
    'INSTALLSHAREDDIR'    => 'C:\\Program Files\\Microsoft SQL Server',
    'INSTALLSHAREDWOWDIR' => 'C:\\Program Files (x86)\\Microsoft SQL Server',
  }
}

}
