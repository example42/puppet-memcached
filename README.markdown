#memcached

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What module memcached affects](#what-modulename-memcached-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with module memcached](#beginning-with-module-memcached)
4. [Usage](#usage)
5. [Operating Systems Support](#operating-systems-support)
6. [Development](#development)

##Overview

This module installs, manages and configures memcached.

##Module Description

The module is based on stdmod naming standars.

Refer to http://github.com/stdmod/ for complete documentation on the common parameters.


If your module has a range of functionality (installation, configuration, management, etc.) this is the time to mention it.

##Setup

###What module memcached affects

* A list of files, packages, services, or operations that the module will alter, impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

###Setup Requirements

* PuppetLabs stdlib
* Puppet version >= 2.7.x


###Beginning with module memcached

To install the package provided by the module just include it:

        include memcached

The main class arguments can be provided either via Hiera or direct parameters:

        class { 'memcached':
          parameter => value,
        }

The module provides also a generic define to manage any memcached configuration file:

        memcached::conf { 'sample.conf':
          content => '# Test',
        }


##Usage

* A common way to use this module involves the management of the main configuration file via a custom template (provided in a custom site module):

        class { 'memcached':
          config_file_template => 'site/memcached/memcached.conf.erb',
        }

* You can write custom templates that use setting provided but the config_file_options_hash paramenter

        class { 'memcached':
          config_file_template      => 'site/memcached/memcached.conf.erb',
          config_file_options_hash  => {
            opt  => 'value',
            opt2 => 'value2',
          },
        }

* Use custom source (here an array) for main configuration file. Note that template and source arguments are alternative.

        class { 'memcached':
          config_file_source => [ "puppet:///modules/site/memcached/memcached.conf-${hostname}" ,
                                  "puppet:///modules/site/memcached/memcached.conf" ],
        }


* Use custom source directory for the whole configuration directory, where present.

        class { 'memcached':
          config_dir_source  => 'puppet:///modules/site/memcached/conf/',
        }

* Use custom source directory for the whole configuration directory and purge all the local files that are not on the dir.
  Note: This option can be used to be sure that the content of a directory is exactly the same you expect, but it is desctructive and may remove files.

        class { 'memcached':
          config_dir_source => 'puppet:///modules/site/memcached/conf/',
          config_dir_purge  => true, # Default: false.
        }

* Use custom source directory for the whole configuration dir and define recursing policy.

        class { 'memcached':
          config_dir_source    => 'puppet:///modules/site/memcached/conf/',
          config_dir_recursion => false, # Default: true.
        }


##Operating Systems Support

This is tested on these OS:
- RedHat osfamily 5 and 6
- Debian 6 and 7
- Ubuntu 10.04 and 12.04


##Development

Pull requests (PR) and bug reports are welcomed.
Well submitting PR please follow these quidelines:
- Provide puppet-lint compliant code
- If possible provide rspec tests
- Follow the module style and stdmod naming standards
