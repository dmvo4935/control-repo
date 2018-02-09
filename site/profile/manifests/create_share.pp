class profile::create_share {

exec {'New-SMBShare –Name “SQLinstallation” –Path “H:\” –FullAccess mydomain\administrator':
   provider  => powershell,
   } 
    
}
