# https://github.com/cucumber/bool/issues/37
Dir.mkdir('win32')
File.open('win32/resolv.rb', 'w') do |io|
  io.write(<<-EOF)
module Win32
  module Resolv
    def get_hosts_path
      '/etc/hosts'
    end
    module_function :get_hosts_path
  end
end
  EOF
end

require 'mkmf'

if CONFIG['CC'] =~ /mingw/
  $CFLAGS << ' -O2' 
elsif CONFIG['CC'] =~ /gcc|clang/
  CONFIG['CC'] = ENV['CC'] if ENV['CC']
  $CFLAGS << ' -O2 -Werror -Wall -Wunused-parameter' 
end

puts "======= compiling with #{CONFIG['CC']}"

extension_name = 'bool_ext'
dir_config(extension_name)

unless find_header('ast.h')
  abort "ast.h is missing."
end

create_makefile(extension_name)
