class profile::create_share {

exec {'New-SMBShare –Name “SQLInstallation” –Path “H:\” –FullAccess mydomain\administrator':
   provider  => powershell,
   }

file {'C:\\Witness':
   ensure => 'directory'
} -> 

exec {'New-SMBShare –Name “Witness” –Path “C:\Witness” –FullAccess mydomain\administrator':
   provider  => powershell,
   }    

}
