# puppet-nrpe - Nagios NRPE management module for Puppet

## Examples

```puppet
# Use defaults
# On Debian systems installs and enables service, enables
# check_disk command for root partition and check_apt command
#
include '::nrpe'
```


```puppet
class { '::nrpe':
  allowed_hosts => [ '127.0.0.1', '10.0.0.6' ],
  commands      => {
    check_disk_root      => {
      command => 'check_disk',
      args    => '-w 20% -c 10% -p /',
    },
    check_disk_wordpress => {
      command => 'check_disk',
      args    => '-w 20% -c 10% -p /var/lib/wordpress/',
    },
    check_apt            => {
      command => 'check_apt',
    },
  },
}
```