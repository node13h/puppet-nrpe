# class nrpe
#
#
# Sample Usage (default config for Debian):
#
#  class {'nrpe':
#    allowed_hosts => [ '127.0.0.1', '1.2.3.4' ],
#    commands      => {
#      check_apt       => {
#        command => 'check_apt',
#      },
#      check_disk_root => {
#        command => 'check_disk',
#        args    => '-w 20% -c 10% -p /',
#      }
#    }
#  }
#

class nrpe (
  $allowed_hosts  = $nrpe::params::allowed_hosts,
  $package_ensure = $nrpe::params::package_ensure,
  $service_ensure = $nrpe::params::service_ensure,
  $service_enable = $nrpe::params::service_enable,

  $config         = $nrpe::params::config,
  $confdir        = $nrpe::params::confdir,
  $plugindir      = $nrpe::params::plugindir,
  $package_name   = $nrpe::params::package_name,
  $service_name   = $nrpe::params::service_name,

  $commands       = $nrpe::params::commands,

) inherits nrpe::params {
  
  validate_array($allowed_hosts)
  validate_string($package_ensure)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_absolute_path($config)
  validate_array($package_name)
  validate_string($service_name)
  validate_absolute_path($confdir)
  validate_absolute_path($plugindir)


  package { $package_name:
    ensure => $package_ensure,
    before => Service[$service_name],
  }

  service { $service_name:
    ensure => $service_ensure,
    enable => $service_enable,
  }

  $allowed_host_list = join($allowed_hosts, ',')

  augeas { 'nrpe':
    context => "/files${config}",
    changes => "set allowed_hosts ${allowed_host_list}",
    notify  => Service[$service_name],
  }

  create_resources(nrpe::command, $commands)

}
