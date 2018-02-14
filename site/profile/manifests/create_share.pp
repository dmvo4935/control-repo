class profile::create_share ($share_name, $path){

exec {'New-SMBShare –Name “$share_name” –Path “$path” –FullAccess mydomain\administrator':
   provider  => powershell,
   } 
    
}
