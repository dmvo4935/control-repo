class profile::mount_iso ($path='c:\installations\en_sql_server_2016_developer_x64_dvd_8777069.iso', $drive='H'){
  mount_iso { $path:
  drive_letter => $drive,
}
}
