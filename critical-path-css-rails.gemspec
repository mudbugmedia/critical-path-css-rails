require File.expand_path('../lib/critical_path_css/rails/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'critical-path-css-rails'
  gem.version     = CriticalPathCSS::Rails::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ['Michael Misshore']
  gem.email       = 'mmisshore@gmail.com'
  gem.summary     = 'Critical Path CSS for Rails!'
  gem.description = 'Only load the CSS you need for the initial viewport in Rails!'
  gem.license     = 'MIT'
  gem.homepage    = 'https://rubygems.org/gems/critical-path-css-rails'

  gem.files        = `git ls-files`.split("\n")
  gem.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_path = 'lib'

  gem.add_development_dependency 'combustion', '~> 1.1', '>= 1.1.0'

  gem.extensions = ['ext/npm/extconf.rb']
end
