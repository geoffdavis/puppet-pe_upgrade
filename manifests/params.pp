class pe::params {

  $upgrade_root        = '/opt/puppet/tmp'
  $installer_tar_file  = "puppet-enterprise-${version}-all.tgz":
  $upgrade_dir         = "puppet-enterprise-${version}-all":
  $upgrader_executable = "${install_root}/${install_dir}/puppet-enterprise-upgrader"
}
