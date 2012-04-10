Puppet Enterprise Upgrade Module
================================

This module will upgrade Puppet Enterprise.

### Required and optional modules

You will need hiera installed to use this module. Hiera has been added to PE
as of version 2.5.0; so you can upgrade your master to get it. If this isn't
an option, you can use the [puppet-hiera][puppet-hiera] module.

[puppet-hiera]: https://github.com/nanliu/puppet-hiera "Puppet module to install hiera"

The puppet-staging module is a prerequisite for this module. You can find it at
the following locations:

  * Puppet Forge: http://forge.puppetlabs.com/nanliu/staging
  * Github: https://github.com/nanliu/puppet-hiera

Usage
-----

You will need to provide several files for this module.

To cut down on size, the Puppet Enterprise installer is not included. You will
need to download 'puppet-enterprise-${version}-all.tar.gz' and place it in
'pe/files'.


You can use the following class definition to pull the download from the
Puppet Labs download server.

    class { 'pe_upgrade':
      version      => '2.0.3',
      answersfile  => "pe/answers/agent.txt.erb",
      download_dir => 'https://pm.puppetlabs.com/puppet-enterprise/2.0.3',
      timeout      => '3600',
    }

You can also locally host the downloads.

### Hosting the installer on the master

    class { 'pe_upgrade':
      version      => '2.0.3',
      answersfile  => "pe/answers/agent.txt.erb",
      download_dir => 'puppet:///site-files/pe/2.0.3',
      timeout      => '3600',
    }

### Hosting the installer on a web server

    class { 'pe_upgrade':
      version      => '2.0.3',
      answersfile  => "pe/answers/agent.txt.erb",
      download_dir => 'http://site.downloads.local/pe/2.0.3',
      timeout      => '3600',
    }

See Also
--------

Please view the documentation in the enclosed manifests specific descriptions
and usage.

Answers Templates
-----------------

Two premade templates are provided; templates/answers/master.txt.erb is a
generic master upgrade answers file; templates/answers/agent.txt.erb is a
generic agent upgrade answers file. Modify them appropriately to fit your
environment.
