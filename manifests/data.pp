class pe_upgrade::data {
  if $::pe_upgrade_version { $version = $::pe_upgrade_version }
  else { $version = '2.5.0' }

  if $::pe_download_dir { $download_dir = $::pe_download_dir }
  else { $download_dir = 'https://pm.puppetlabs.com/puppet-enterprise/2.5.0/' }

  if $::pe_answersfile { $answersfile = $pe_answersfile }
  else { $answersfile = "pe_upgrade/answers/agent.txt.erb" }
}
