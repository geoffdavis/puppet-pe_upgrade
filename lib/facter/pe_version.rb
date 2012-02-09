# = Puppet enterprise version facts
#
# == Resolution:
#
# Parses the puppetversion fact and extracts the relevant substrings
#
{
  :pe_version       => /\(Puppet Enterprise\s+([\d.]+)\)/,
  :pe_major_release => /\(Puppet Enterprise\s+(\d+)\.\d+\.\d+\)/,
  :pe_minor_release => /\(Puppet Enterprise\s+\d+\.(\d+)\.\d+\)/,
  :pe_patch_release => /\(Puppet Enterprise\s+\d+\.\d+\.(\d+)\)/,
}.each_pair do |fact_name, fact_regex|

  setcode do
    if Facter.value(:puppetversion).match(fact_regex)
      $1
    end
  end
end

