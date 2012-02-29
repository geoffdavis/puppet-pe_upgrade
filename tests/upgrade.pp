class { 'pe_upgrade':
  version      => '2.0.3',
  answersfile  => "pe/answers/agent.txt.erb",
  download_dir => 'https://pm.puppetlabs.com/puppet-enterprise/2.0.3',
  timeout      => '3600',
}

