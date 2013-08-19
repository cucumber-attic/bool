Gem::Specification.new do |s|
  s.name    = "bool"
  s.version = "1.0.18"
  s.summary = "Boolean expression evaluator"
  s.author  = "Aslak Hellesøy"
  
  s.files = Dir.glob("lib/**/*.rb")
  s.add_development_dependency('rake')
  s.add_development_dependency('bundler', '~> 1.3.5')
  
  if ENV['RUBY_PLATFORM'] == 'java' || RUBY_PLATFORM =~ /java/
    s.platform = "java"
    s.files << "lib/#{s.name}_ext.jar"
  elsif ENV['RUBY_PLATFORM'] == 'x86-mingw32'
    s.platform = "x86-mingw32"
    s.files << "lib/#{s.name}_ext.so"
  else
    s.extensions << "ext/#{s.name}_ext/extconf.rb"
    s.files += Dir.glob("ext/**/*.{c,h,rb}")
    s.add_development_dependency('rake-compiler', '~> 0.9.1')
  end
end
