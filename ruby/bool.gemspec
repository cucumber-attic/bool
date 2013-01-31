Gem::Specification.new do |s|
  s.name    = "bool"
  s.version = "1.0.0"
  s.summary = "Boolean expression parser"
  s.author  = "Aslak Hellesøy"
  
  s.files = Dir.glob("lib/**/*.rb")
  
  if RUBY_PLATFORM =~ /java/
    s.platform = "java"
    s.files << "lib/bool_ext.jar"
  else
    s.extensions << "ext/bool_ext/extconf.rb"
    s.files.concat << Dir.glob("ext/**/*.{c,rb}")
    s.add_development_dependency('rake-compiler', '>= 0.8.2')
  end
end
