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

