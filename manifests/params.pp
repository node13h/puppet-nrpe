class nrpe::params {

  $allowed_hosts        = [ '127.0.0.1' ]

  $package_ensure       = 'present'
  $service_ensure       = 'running'
  $service_enable       = true

  # Defaults
  $default_config       = '/etc/nagios/nrpe.cfg'
  $default_confdir      = '/etc/nagios/nrpe.d'
  $default_plugindir    = '/usr/lib/nagios/plugins'

  $default_package_name = [ 'nagios-nrpe-server' ]
  $default_service_name = 'nagios-nrpe-server'

  $default_commands     = {
    check_disk_root => {
      command => 'check_disk',
      args    => '-w 20% -c 10% -p /',
    }
  }

  case $::osfamily {
    'Debian': {
      $config       = $default_config
      $confdir      = $default_confdir
      $plugindir    = $default_plugindir
      $package_name = $default_package_name
      $service_name = $default_service_name

      $_debian_commands = {
        check_apt => {
          command => 'check_apt',
        }
      }

      $commands     = merge($default_commands, $_debian_commands)
    }

    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }

}
