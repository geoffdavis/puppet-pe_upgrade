class pe::upgrade(
  $version,
  $answersfile = 'UNSET',
  $cleanup     = false
) {

  include pe::params

  # TODO validate $version
  # ostensibly using kwalify

  if $version == $::pe_version {
    notify { "Puppet Enterprise at desired version: ${version}": }
  }
  else {

    $upgrade_root        = '/opt/puppet/upgrade'
    $installer_tar_file  = "puppet-enterprise-${version}-all.tgz":
    $upgrade_dir         = "puppet-enterprise-${version}-all":
    $upgrader_executable = "${upgrade_root}/${upgrade_dir}/puppet-enterprise-upgrader"

    if $answersfile {
      $answersfile_source = $answersfile
    }
    else {
      $answersfile_source = "puppet:///modules/pe/answers/${hostname}.txt"
    }
    $answersfile_dest = "${upgrade_root}/answers.txt"

    file { $upgrade_root:
      ensure => directory,
      owner  => 0,
      group  => 0,
    }

    file { "${upgrade_root}/${installer_tar_file}":
      ensure => present,
      source => "puppet:///modules/pe/${installer_tar_file}"
      owner  => 0,
      group  => 0,
      require => File[$install_root],
    }

    file { $answersfile_dest:
      ensure  => present,
      source  => $answersfile_source,
      owner   => 0,
      group   => 0,
      require => File[$upgrade_root],
    }

    exec { 'extract_installer',
      command   => "tar xf ${upgrade_root}/${installer_tar_file} -C ${upgrade_root}"
      path      => ['/usr/bin', '/bin'],
      creates   => "${upgrade_root}/${upgrade_dir}"
      user      => 0,
      group     => 0,
      logoutput => on_failure,
      require   => File[$upgrade_root, "${upgrade_root}/${installer_tar_file}"],
    }

    exec { 'run_upgrader':
      command => "${upgrader_executable} -a ${answerfile_path}",
      path    => ['/usr/bin', '/bin']
      user    => 0,
      group   => 0,
      require => [
        Exec['extract_installer'],
        File[$answersfile_dest],
      ],
    }

    if $cleanup {
      exec { 'remove_upgrader_files':
        command => "/bin/rm -rf ${upgrade_root}"
        user    => 0,
        group   => 0,
        require => Exec['run_upgrader'],
      }
    }
  }
}
