require 'mkmf'

LIBBOOL = File.expand_path(File.dirname(__FILE__) + '/libbool')
HEADER_DIRS = [LIBBOOL, RbConfig::CONFIG['includedir']]
LIB_DIRS = [LIBBOOL, RbConfig::CONFIG['libdir']]

Dir.chdir(LIBBOOL) do
  system 'make clean all'
end

extension_name = 'bool_ext'
dir_config(extension_name, HEADER_DIRS, LIB_DIRS)

unless find_header('bool_ast.h')
  abort "bool_ast.h is missing."
end
unless find_library('bool', 'parse_bool_ast')
  abort "libbool is missing."
end

create_makefile(extension_name)
