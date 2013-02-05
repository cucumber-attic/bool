require 'mkmf'

$CFLAGS << ' -O2 -Wall -Werror' if CONFIG['CC'] =~ /gcc|clang/

extension_name = 'bool_ext'
dir_config(extension_name)

unless find_header('ast.h')
  abort "ast.h is missing."
end

create_makefile(extension_name)
