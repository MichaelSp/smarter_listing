$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "smarter_listing/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "smarter_listing"
  s.version     = SmarterListing::VERSION
  s.authors     = ["Michael Sprauer"]
  s.email       = ["ms@inline.de"]
  s.homepage    = "http://github.com/MichaelSp/smarter_listing"
  s.summary     = "Smart Listing even smarter (and DRYer)"
  s.description = "Smart Listing even smarter (and DRYer)"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4"
  s.add_dependency 'smart_listing'

  s.add_development_dependency "sqlite3"
end
