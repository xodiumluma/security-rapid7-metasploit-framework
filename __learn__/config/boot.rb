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