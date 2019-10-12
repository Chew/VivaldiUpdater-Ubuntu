Gem::Specification.new do |s|
  s.name = 'vivaldiupdater-ubuntu'
  s.version = '0.1.1'
  s.date = '2019-10-12'
  s.executables << 'vivaldiupdater'
  s.summary = 'A ruby gem to simplify updating Vivaldi!'
  s.description = 'A ruby gem to simplify updating Vivaldi (for Ubuntu)!'
  s.authors = ['Chew']
  s.email = 'chew@chew.pw'
  s.files = ['lib/vivaldiupdater.rb']
  s.homepage = 'http://github.com/Chew/VivaldiUpdater-Ubuntu'
  s.license = 'MIT'
  s.add_runtime_dependency 'nokogiri', '~> 1.10', '>= 1.10.4'
  s.add_runtime_dependency 'rest-client', '~> 2.1.0'
  s.required_ruby_version = '>= 2.2.4'
end
