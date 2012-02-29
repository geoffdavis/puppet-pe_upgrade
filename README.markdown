Puppet Enterprise Upgrade Module
================================

This module will upgrade Puppet Enterprise.

Requirements
------------

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
