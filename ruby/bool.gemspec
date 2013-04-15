Gem::Specification.new do |s|
  s.name    = "bool"
  s.version = "1.0.16"
  s.summary = "Boolean expression evaluator"
  s.author  = "Aslak Hellesøy"
  
  s.files = Dir.glob("lib/**/*.rb")
  s.add_development_dependency('rake')
  s.add_development_dependency('bundler', '~> 1.3.0')
  
  if ENV['RUBY_PLATFORM'] == 'java' || RUBY_PLATFORM =~ /java/
    s.platform = "java"
    s.files << "lib/bool_ext.jar"
  elsif ENV['RUBY_PLATFORM'] == 'x86-mingw32'
    s.platform = "x86-mingw32"
    s.files << "lib/bool_ext.so"
  else
    s.extensions << "ext/bool_ext/extconf.rb"
    s.files += Dir.glob("ext/**/*.{c,h,rb}")
    s.add_development_dependency('rake-compiler', '>= 0.8.3')
  end
end
