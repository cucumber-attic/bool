require 'mkmf'

LIBBOOL = File.expand_path('../libbool', __FILE__)
HEADER_DIRS = [LIBBOOL, RbConfig::CONFIG['includedir']]
LIB_DIRS = [LIBBOOL, RbConfig::CONFIG['libdir']]

Dir.chdir(LIBBOOL) do
  puts RbConfig::CONFIG["CC"]
  puts RbConfig::CONFIG["AR"]
  puts RbConfig::CONFIG["LDSHARED"]
  ENV["CC"] = RbConfig::CONFIG["CC"]
  ENV["AR"] = RbConfig::CONFIG["AR"]
  ENV["LDSHARED"] = RbConfig::CONFIG["LDSHARED"]
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
