class pe::upgrade(
  $version,
  $answersfile = 'UNSET',
  $cleanup     = false
) {

  # TODO validate $version
  # ostensibly using kwalify

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
