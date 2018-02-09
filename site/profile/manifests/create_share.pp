class profile::create_share {

exec {'New-SMBShare –Name “SQLinstallation” –Path “H:\” –ContinuouslyAvailable –FullAccess mydomain\administrator':
   provider  => powershell,
   } 
    
}
