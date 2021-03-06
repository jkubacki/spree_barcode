# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_barcode'
  s.version     = '2.2'
  s.summary     = 'spree extenstion for simple barcode generation.'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Jakub Kubacki'
  s.email     = 'kubacki.jk@gmail.com'
  s.homepage  = 'https://github.com/jkubacki'

  #s.uploads       = `git ls-uploads`.split("\n")
  #s.test_files  = `git ls-uploads -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.2'
  s.add_dependency 'barby'
  s.add_dependency 'prawn'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
