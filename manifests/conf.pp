#
# = Define: memcached::conf
#
# With this define you can manage any memcached configuration file
#
# == Parameters
#
# [*template*]
#   String. Optional. Default: undef. Alternative to: source, content.
#   Sets the module path of a custom template to use as content of
#   the config file
#   When defined, config file has: content => content($template),
#   Example: template => 'site/memcached/my.conf.erb',
#
# [*content*]
#   String. Optional. Default: undef. Alternative to: template, source.
#   Sets directly the value of the file's content parameter
#   When defined, config file has: content => $content,
#   Example: content => "# File Managed by Puppet \n",
#
# [*source*]
#   String. Optional. Default: undef. Alternative to: template, content.
#   Sets the value of the file's source parameter
#   When defined, config file has: source => $source,
#   Example: source => 'puppet:///site/memcached/my.conf',
#
# [*ensure*]
#   String. Default: present
#   Manages config file presence. Possible values:
#   * 'present' - Create and manages the file.
#   * 'absent' - Remove the file.
#
# [*path*]
#   String. Optional. Default: $config_dir/$title
#   The path of the created config file. If not defined a file
#   name like the  the name of the title a custom template to use as content of configfile
#   If defined, configfile file has: content => content("$template")
#
# [*mode*] [*owner*] [*group*] [*notify*] [*require*] [*replace*]
#   String. Optional. Default: undef
#   All these parameters map directly to the created file attributes.
#   If not defined the module's defaults are used.
#   If defined, config file file has, for example: mode => $mode
#
# [*options_hash*]
#   Hash. Default undef. Needs: 'template'.
#   An hash of custom options to be used in templates to manage any key pairs of
#   arbitrary settings.
#
define memcached::conf (

  $source       = undef,
  $template     = undef,
  $content      = undef,

  $path         = undef,
  $mode         = undef,
  $owner        = undef,
  $group        = undef,
  $notify       = undef,
  $require      = undef,
  $replace      = undef,

  $options_hash = undef,

  $ensure       = present ) {

  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent the conf file is removed.')

  include memcached

  $managed_path = $path ? {
    undef   => "${memcached::config_dir_path}/${name}",
    default => $path,
  }

  $managed_content = $content ? {
    undef   => $template ? {
      undef => undef,
      default => template($template),
    },
    default => $content,
  }

  $managed_mode = $mode ? {
    undef   => $memcached::config_file_mode,
    default => $mode,
  }

  $managed_owner = $owner ? {
    undef   => $memcached::config_file_owner,
    default => $owner,
  }

  $managed_group = $group ? {
    undef   => $memcached::config_file_group,
    default => $group,
  }

  $managed_require = $require ? {
    undef   => $memcached::config_file_require,
    default => $require,
  }

  $managed_notify = $notify ? {
    undef   => $memcached::config_file_notify,
    default => $notify,
  }

  $managed_replace = $replace ? {
    undef   => $memcached::config_file_replace,
    default => $replace,
  }

  file { "memcached_conf_${name}":
    ensure  => $ensure,
    source  => $source,
    content => $managed_content,
    path    => $managed_path,
    mode    => $managed_mode,
    owner   => $managed_owner,
    group   => $managed_group,
    require => $managed_require,
    notify  => $managed_notify,
    replace => $managed_replace,
  }

}

