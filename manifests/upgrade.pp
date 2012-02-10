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
  $version     = '2.0.2',
  $answersfile = 'UNSET',
  $cleanup     = false
) {

  if $version == $::pe_version {
    notify { 'pe-upgrade status':
      message => "Puppet Enterprise at desired version: ${version}",
    }
  }
  else {

    $upgrade_root        = "/opt/puppet/upgrade-${version}"
    $installer_tar_file  = "puppet-enterprise-${version}-all.tar.gz"
    $upgrade_dir         = "puppet-enterprise-${version}-all"
    $upgrader_executable = "${upgrade_root}/${upgrade_dir}/puppet-enterprise-upgrader"

    if $answersfile == 'UNSET' {
      $answersfile_source = "pe/answers/${::hostname}.txt.erb"
    }
    else {
      $answersfile_source = $answersfile
    }
    $answersfile_dest = "${upgrade_root}/answers.txt"

    file { $upgrade_root:
      ensure => directory,
      owner  => 0,
      group  => 0,
    }

    file { "${upgrade_root}/${installer_tar_file}":
      ensure  => present,
      source  => "puppet:///modules/pe/${installer_tar_file}",
      backup  => false,
      owner   => 0,
      group   => 0,
    }

    file { $answersfile_dest:
      ensure  => present,
      content => template($answersfile_source),
      owner   => 0,
      group   => 0,
      require => File[$upgrade_root],
    }

    exec { 'Extract installer':
      command   => "tar xf ${upgrade_root}/${installer_tar_file} -C ${upgrade_root}",
      path      => ['/usr/bin', '/bin'],
      creates   => "${upgrade_root}/${upgrade_dir}",
      user      => 0,
      group     => 0,
      logoutput => on_failure,
      require   => File[$upgrade_root, "${upgrade_root}/${installer_tar_file}"],
    }

    exec { 'Run upgrade':
      command   => "${upgrader_executable} -a ${answersfile_dest}",
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
      require   => [
        Exec['Extract installer'],
        File[$answersfile_dest],
      ],
    }

    if $cleanup {
      exec { 'Remove upgrader files':
        command => "/bin/rm -rf ${upgrade_root}",
        user    => 0,
        group   => 0,
        require => Exec['Run upgrade'],
      }
    }
  }
}
