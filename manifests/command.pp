# define nrpe::command
#
#
# Sample Usage:
#
#  nrpe::command {'check_disk_root':
#    command => 'check_disk',
#    args    => '-w 20% -c 10% -p /',
#  }
#

define nrpe::command (
  $command,
  $args   = undef,
  $ensure = 'present',
) {

  include '::nrpe'

  validate_string($command)

  if $args != undef {
    validate_string($args)
    $full_command = "${command} ${args}"
  } else {
    $full_command = $command
  }

  file { "${::nrpe::confdir}/${name}.cfg":
    ensure  => $ensure,
    content => "command[${name}]=${::nrpe::plugindir}/${full_command}\n",
    notify  => Service[$::nrpe::service_name],
    require => Package[$::nrpe::package_name],
  }

}
