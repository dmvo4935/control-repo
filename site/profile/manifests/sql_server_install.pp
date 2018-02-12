class profile::sql_server_install {

$sql_source = '\\10.0.10.7\SQLInstallation'

#sqlserver_instance{ 'MSSQLSERVER':
#  source                  => $sql_source,
#  features                => ['SQL'],
#  install_switches        => {
#    'TCPENABLED'          => 1,
#    'SQLBACKUPDIR'        => 'C:\\MSSQLSERVER\\backupdir',
#    'SQLTEMPDBDIR'        => 'C:\\MSSQLSERVER\\tempdbdir',
#    'INSTALLSQLDATADIR'   => 'C:\\MSSQLSERVER\\datadir',
#    'INSTANCEDIR'         => 'C:\\Program Files\\Microsoft SQL Server',
#    'INSTALLSHAREDDIR'    => 'C:\\Program Files\\Microsoft SQL Server',
#    'INSTALLSHAREDWOWDIR' => 'C:\\Program Files (x86)\\Microsoft SQL Server',
#  }


#exec {'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force': 
#     provider => powershell, 
#    } -> 

#exec {"Set-PSRepository -Name \"PSGallery\" -InstallationPolicy Trusted -SourceLocation 'https://www.powershellgallery.com/api/v2/'": provider => powershell, } ->

#exec {'Install SqlserverDsc module':
#     command  => 'Find-Module -Name SqlServerDsc -Repository PSGallery | Install-Module',
#     provider => powershell, 
#    } ->


 dsc_xsqlserverinstall {'Install SQL Server': 
   dsc_instancename =>  'MSSQLSERVER',
   dsc_features     =>  'SQLENGINE,AS',
   dsc_sourcepath   => $sql_source,
   dsc_sourcepathcredential => {
    'user'      =>  'mydomain\administrator',
    'password'  =>  'Supersecret#123'
    },
  # dsc_installshareddir     => 'C:\Program Files\Microsoft SQL Server',
  # dsc_installsharedwowdir  => 'C:\Program Files (x86)\Microsoft SQL Server',
  # dsc_instancedir          => 'C:\Program Files\Microsoft SQL Server',
   dsc_installsqldatadir    => 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data',
   dsc_sqluserdbdir         => 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data',
   dsc_sqluserdblogdir      => 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data',
   dsc_sqltempdbdir         => 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data',
  # dsc_sqltempdblogdir      => 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data',
  # dsc_sqlbackupdir         => 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup',
  # dsc_asconfigdir          => 'C:\MSOLAP\Config',
  # dsc_asdatadir            => 'C:\MSOLAP\Data',
  # dsc_aslogdir             => 'C:\MSOLAP\Log',
  # dsc_asbackupdir          => 'C:\MSOLAP\Backup',
  # dsc_astempdir            => 'C:\MSOLAP\Temp',
   dsc_sqlcollation         => 'SQL_Latin1_General_CP1_CI_AS',
   dsc_sqladministratorcredential        => {
     'user'      => 'mydomain\administrator',
     'password'  => 'Supersecret#123'
    },
   dsc_svcaccount        => 'mydomain\administrator',
   dsc_agentsvcaccount        => 'mydomain\administrator',
   #dsc_assvcaccount        => {
   #  'user'      => 'mydomain\administrator',
   #  'password'  => 'Supersecret#123',
   # }, 
   dsc_sysadminaccounts => 'mydomain\administrator',
   #dsc_assysadminaccounts  => 'mydomain\administrator',
   }

}
