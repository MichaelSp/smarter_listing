$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'smarter_listing/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'smarter_listing'
  s.version     = SmarterListing::VERSION
  s.authors     = ['Michael Sprauer']
  s.email       = ['ms@inline.de']
  s.homepage    = 'http://github.com/MichaelSp/smarter_listing'
  s.summary     = 'Smart Listing even smarter (and DRYer)'
  s.description = 'DRY improvements to the fine gem "smart_listing". See http://showcase.sology.eu/smart_listing for more details'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 6'

  s.add_dependency 'smart_listing', '~> 1'

  s.add_development_dependency 'sqlite3', '~> 1'
  s.add_development_dependency 'minitest-rails', "~> 6"
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'selenium-webdriver'
  #s.add_development_dependency 'spring'
end
