#memcached

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with [Modulename]](#setup)
    * [What [Modulename] affects](#what-[modulename]-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with [Modulename]](#beginning-with-[Modulename])
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module installs, manages and configures memcached.

##Module Description

The module is based on stdmod naming standars.
Refer to http://github.com/stdmod/ for complete documentation on the common parameters.


If applicable, this section should have a brief description of the technology the module integrates with and what that integration enables. This section should answer the questions: "What does this module *do*?" and "Why would I use it?"
    
If your module has a range of functionality (installation, configuration, management, etc.) this is the time to mention it.

##Setup

###What [Modulename] affects

* A list of files, packages, services, or operations that the module will alter, impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form. 

###Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled, etc.), mention it here.

###Beginning with [Modulename]

A common way to use this module involves its install

        class { 'memcached':
          config_template => 'site/memcached/memcached.conf.erb',
        }


##Usage


AGE - Overrides and Customizations
* Use custom source for main configuration file 

        class { 'memcached':
          config_file_source => [ "puppet:///modules/example42/memcached/memcached.conf-${hostname}" ,
                           "puppet:///modules/example42/memcached/memcached.conf" ], 
        }


* Use custom source directory for the whole configuration dir.

        class { 'memcached':
          config_dir_source  => 'puppet:///modules/example42/memcached/conf/',
        }

* Use custom source directory for the whole configuration dir purging all the local files that are not on the dir.
  Note: This option can be used to be sure that the content of a directory is exactly the same you expect, but it is desctructive and may remove files.

        class { 'memcached':
          config_dir_source => 'puppet:///modules/example42/memcached/conf/',
          config_dir_purge  => true, # Default: false.
        }

* Use custom source directory for the whole configuration dir and define recursing policy.

        class { 'memcached':
          config_dir_source    => 'puppet:///modules/example42/memcached/conf/',
          config_dir_recursion => false, # Default: true.
        }

* Use custom template for main config file. Note that template and source arguments are alternative.

        class { 'memcached':
          config_file_template => 'example42/memcached/memcached.conf.erb',
        }

* Use a custom template and provide an hash of custom configurations that you can use inside the template

        class { 'memcached':
          config_file_template      => 'example42/memcached/memcached.conf.erb',
          config_file_options_hash  => {
            opt  => 'value',
            opt2 => 'value2',
          },
        }



* Automatically include a custom class with extra resources related to memcached.
  Here is loaded $modulepath/example42/manifests/my_memcached.pp.
  Note: Use a subclass name different than memcached to avoid order loading issues.

        class { 'memcached':
         my_class => 'site::memcached_my',
        }


##Operating Systems Support

This is tested on these OS:
- RedHat osfamily 5 and 6
- Debian 6 and 7
- Ubuntu 10.04 and 12.04
