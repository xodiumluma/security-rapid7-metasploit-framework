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
  $stderr.puts "[*] Couldn't load bundler; thus this error:"
  $stderr.puts
  $stderr.puts "  '#{e}'"
  $stderr.puts
  $stderr.puts "[*] Might need to remove/upgrade bundler"
  exit(1)
end
lib_path = root.join('lib').to_path
unless $LOAD_PATH.include? lib_path
  $LOAD_PATH.unshift lib_path
end
require 'digest'  
require 'metasploit/framework/version'
require 'msf/base/config'
# If necessary, invalidate and delete the bootsnap cache.
# Illustration: the metasploit framework version is updated.
#
# @param [Hash] bootsnap_config Check out https://github.com/Shopify/bootsnap/blob/95e8d170aea99a831fd484ce09ad2f195644e740/lib/bootsnap.rb#L38
# @return [void]
def invalidate_bootstrap_cache!(bootsnap_config)
  expected_cache_metadata