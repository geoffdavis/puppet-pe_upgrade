# == Class: pe::upgrade
#
# This class will perform the upgrade of PE to the specified version. Temporary
# files for the installer will be placed in /opt/puppet/upgrade-${version}
#
# == Parameters
#
# [*version*]
#
# The version of PE to upgrade to. Must be in the form of
# <major release>.<minor release>.<patch release>
# For example, 2.0.2
#
# [*answersfile*]
#
# The path to a PE answers file. Defaults to the template
# "pe/answers/${::hostname}.txt.erb"
#
# [*cleanup*]
#
# Whether to remove upgrade files after installation. Defaults to false.
#
# == Examples
#
#   # Minimal
#   class { 'pe::upgrade':
#     version => '2.0.2',
#   }
#
#   # More customized
#   class { 'pe::upgrade':
#     version     => '2.0.2',
#     answersfile => "site/answers/${fqdn}-answers.txt",
#     cleanup     => true,
#  }
#
# == Caveats
#
# This has only been tested for PE versions 2.0.0 and greater.
#
# == Authors
#
# Adrien Thebo <adrien@puppetlabs.com>
#
# == Copyright
#
# Copyright 2012 Puppet Labs Inc.
#
# == License
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class pe::upgrade(
  $version      = '2.0.2',
  $answersfile  = "pe/answers/${::hostname}.txt.erb",
  $download_dir = '/vagrant/files/',
  $timeout      = undef
) {

  if $version == $::pe_version {
    notify { 'pe-upgrade status':
      message => "Puppet Enterprise at desired version: ${version}",
    }
  }
  else {
    require staging

    ############################################################################
    # Munge variables
    ############################################################################

    $installer_tar       = "puppet-enterprise-${version}-all.tar.gz"
    $installer_dir       = "puppet-enterprise-${version}-all"

    $source_url = "${download_dir}/${installer_tar}"

    $upgrader = "${staging::path}/pe/${installer_dir}/puppet-enterprise-upgrader"

    ############################################################################
    # Stage the installer
    ############################################################################

    staging::file { $installer_tar:
      source  => $source_url,
      timeout => $timeout,
    }

    staging::extract { $installer_tar:
      target  => "${staging::path}/pe",
      require => Staging::File[$installer_tar],
    }

    ############################################################################
    # XXX Bullshit
    ############################################################################

    $answersfile_dest = "${staging::path}/pe/answers.txt"

    file { $answersfile_dest:
      ensure  => present,
      content => template($answersfile),
      owner   => 0,
      group   => 0,
      require => File["${staging::path}/pe"],
    }

    ############################################################################
    # Validate and perform upgrade
    ############################################################################

    exec { 'Validate answers':
      command   => "${upgrader} -n -a ${answersfile_dest}",
      path      => [
        '/usr/bin',
        '/bin',
        '/usr/local/bin',
        '/usr/sbin',
        '/sbin',
        '/usr/local/sbin'
      ],
      user      => 0,
      group     => 0,
      logoutput => on_failure,
      require   => Staging::Extract[$installer_tar],
    }

    exec { 'Run upgrade':
      command   => "${upgrader} -a ${answersfile_dest}",
      path      => [
        '/usr/bin',
        '/bin',
        '/usr/local/bin',
        '/usr/sbin',
        '/sbin',
        '/usr/local/sbin'
      ],
      user      => 0,
      group     => 0,
      logoutput => on_failure,
      require   => Exec['Validate answers'],
    }
  }
}
