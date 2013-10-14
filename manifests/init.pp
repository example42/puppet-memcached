#
# = Class: memcached
#
# This class installs and manages memcached
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for the official
# documentation for standard parameters usage.
#
class memcached (

  $ensure                = 'present',
  $version               = undef,

  $package_name          = $memcached::params::package_name,

  $service_name          = $memcached::params::service_name,
  $service_ensure        = 'running',
  $service_enable        = true,

  $config_file_path             = $memcached::params::config_file_path,
  $config_file_replace          = $memcached::params::config_file_replace,
  $config_file_require          = 'Package[memcached]',
  $config_file_notify           = 'Service[memcached]',
  $config_file_source           = undef,
  $config_file_template         = undef,
  $config_file_content          = undef,
  $config_file_options_hash     = undef,

  $config_dir_path              = $memcached::params::config_dir_path,
  $config_dir_source            = undef,
  $config_dir_purge             = false,
  $config_dir_recurse           = true,

  $dependency_class      = undef,
  $my_class              = undef,

  $monitor_class         = undef,
  $monitor_options_hash  = { } ,

  $firewall_class        = undef,
  $firewall_options_hash = { } ,

  $scope_hash_filter     = '(uptime.*|timestamp)',

  $port                  = undef,
  $protocol              = undef,

  ) inherits memcached::params {


  # Input parameters validation

  validate_re($ensure, ['present','absent'], 'Valid values: present, absent.')
  validate_bool($service_enable)
  validate_bool($config_dir_recurse)
  validate_bool($config_dir_purge)
  if $config_file_options_hash { validate_hash($config_file_options_hash) }
  if $monitor_options_hash { validate_hash($monitor_options_hash) }
  if $firewall_options_hash { validate_hash($firewall_options_hash) }


  # Calculation of variables used in the module

  $config_file_owner          = $memcached::params::config_file_owner
  $config_file_group          = $memcached::params::config_file_group
  $config_file_mode           = $memcached::params::config_file_mode

  if $config_file_content {
    $managed_config_file_content = $config_file_content
  } else {
    if $config_file_template {
      $managed_config_file_content = template($config_file_template)
    } else {
      $managed_config_file_content = undef
    }
  }

  if $version {
    $managed_package_ensure = $version
  } else {
    $managed_package_ensure = $ensure
  }

  if $ensure == 'absent' {
    $managed_service_enable = undef
    $managed_service_ensure = stopped
    $config_dir_ensure = absent
    $config_file_ensure = absent
  } else {
    $managed_service_enable = $service_enable
    $managed_service_ensure = $service_ensure
    $config_dir_ensure = directory
    $config_file_ensure = present
  }


  # Resources Managed

  if $memcached::package_name {
    package { $memcached::package_name:
      ensure   => $memcached::managed_package_ensure,
    }
  }

  if $memcached::service_name {
    service { $memcached::service_name:
      ensure     => $memcached::managed_service_ensure,
      enable     => $memcached::managed_service_enable,
    }
  }

  if $memcached::config_file_path {
    file { 'memcached.conf':
      ensure  => $memcached::config_file_ensure,
      path    => $memcached::config_file_path,
      mode    => $memcached::config_file_mode,
      owner   => $memcached::config_file_owner,
      group   => $memcached::config_file_group,
      source  => $memcached::config_file_source,
      content => $memcached::managed_config_file_content,
      notify  => $memcached::config_file_notify,
      require => $memcached::config_file_require,
    }
  }

  if $memcached::config_dir_source {
    file { 'memcached.dir':
      ensure  => $memcached::config_dir_ensure,
      path    => $memcached::config_dir_path,
      source  => $memcached::config_dir_source,
      recurse => $memcached::config_dir_recurse,
      purge   => $memcached::config_dir_purge,
      force   => $memcached::config_dir_purge,
      notify  => $memcached::config_file_notify,
      require => $memcached::config_file_require,
    }
  }


  # Extra classes

  if $memcached::dependency_class {
    include $memcached::dependency_class
  }

  if $memcached::my_class {
    include $memcached::my_class
  }

  if $memcached::monitor_class {
    class { $memcached::monitor_class:
      options_hash => $memcached::monitor_options_hash,
      scope_hash   => {}, # TODO: Find a good way to inject class' scope
    }
  }

  if $memcached::firewall_class {
    class { $memcached::firewall_class:
      options_hash => $memcached::firewall_options_hash,
      scope_hash   => {},
    }
  }

}

