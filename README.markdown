Puppet Enterprise Upgrade Module
================================

This module will upgrade Puppet Enterprise

Requirements
------------

You will need to provide several files for this module.

To cut down on size, the Puppet Enterprise installer is not included. You will
need to download 'puppet-enterprise-${version}-all.tar.gz' and place it in
'pe/files'.

You will also need to provide answers files for each node you plan to upgrade.
You can either define a generic template that all nodes can use, or define a
template for each node you plan on upgrading.

See Also
--------

Please view the documentation in the enclosed manifests specific descriptions
and usage.

Example Answers Template
------------------------

This template could be used to upgrade a generic Puppet agent installation.

    q_install=y
    q_puppet_cloud_install=n
    q_puppet_enterpriseconsole_install=n
    q_puppetagent_install=y
    q_puppetagent_server=<%= scope.lookupvar('::server') %>
    q_puppetmaster_install=n
    q_rubydevelopment_install=n
    q_upgrade_install_wrapper_modules=n
    q_upgrade_installation=y
    q_upgrade_remove_mco_homedir=n
    q_vendor_packages_install=y
