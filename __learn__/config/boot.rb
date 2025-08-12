require 'pathname'
require 'rubygems'
GEMFILE_EXTENSIONS = [
  '.local',
  ''
]
msfenv_real_pathname = Pathname.new(__FILE__).realpath
root = msfenv_real_pathname.parent.parent
unless ENV['BUNDLE_GEMFILE']
  require 'pathname'
  GEMFILE_EXTENSIONS.each do |extension|
    extension_pathname = root.join("Gemfile#{extension}")
    if extension_pathname.readable?
      ENV['BUNDLE_GEMFILE'] = extension_pathname.to_path
      break
    end
  end
end

begin
  require 'bundler/setup'
rescue LoadError => e 
  $stderr.puts "[*] Bundler didn't load, but got this error:"
  $stderr.puts = "  '#{e}'"
  $stderr.puts "[*] Either reinstall or upgrade bundler"
  exit(1)
end

lib_path = root.join('lib').to_path 
unless $LOAD_PATH.include? lib_path
  $LOAD_PATH.unshift lib_path
end

require 'digest'
require 'metasploit/framework/version'
require 'msf/base/config'
# invalidate and delete bootsnap cache if needed; eg metasploit framework version is updated
# @param [Hash] bootsnap_config See https://github.com/Shopify/bootsnap/blob/95e8d170aea99a831fd484ce09ad2f195644e740/lib/bootsnap.rb#L38
# @return [void]
def invalidate_bootsnap_cache!(bootsnap_config) 
  expected_cache_metadata = {
    'metasploit_framework_version' => Metasploit::Framework::Version::VERSION,
    'ruby_description' => RUBY_DESCRIPTION,
    'bundler_lockfile_hash' => Digest::MD5.hexdigest(Bundler.read_file(Bundler.default_lockfile)),
    'bootsnap_config' => {
      'load_path_cache' => bootsnap_config[:load_path_cache],
      'compile_cache_iseq' => bootsnap_config[:compile_cache_iseq],
      'compile_cache_yaml' => bootsnap_config[:compile_cache_yaml],
    }
  }


