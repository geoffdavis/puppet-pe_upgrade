# = Puppet enterprise version facts
#
# == Resolution:
#
# Parses the puppetversion fact and extracts the relevant substrings
#
{
  :pe_version       => /\(Puppet Enterprise\s+([\d.]+)\)/,
  :pe_major_version => /\(Puppet Enterprise\s+(\d+)\.\d+\.\d+\)/,
  :pe_minor_version => /\(Puppet Enterprise\s+\d+\.(\d+)\.\d+\)/,
  :pe_patch_version => /\(Puppet Enterprise\s+\d+\.\d+\.(\d+)\)/,
}.each_pair do |fact_name, fact_regex|

  Facter.add(fact_name) do
    setcode do
      if Facter.value(:puppetversion).match(fact_regex)
        $1
      end
    end
  end
end
