require File.expand_path('../lib/critical_path_css/rails/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'critical-path-css-rails'
  s.version     = CriticalPathCSS::Rails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Michael Misshore']
  s.email       = 'mmisshore@gmail.com'
  s.summary     = 'Critical Path CSS for Rails!'
  s.description = 'Only load the CSS you need for the initial viewport in Rails!'
  s.license     = 'MIT'

  s.add_runtime_dependency 'phantomjs', ['~> 1.9']

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path = 'lib'
end
