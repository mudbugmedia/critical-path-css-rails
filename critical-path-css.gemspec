Gem::Specification.new do |s|
  s.name        = 'critical-path-css'
  s.version     = '0.0.0'
  s.date        = '2015-08-27'
  s.summary     = 'Critical Path CSS'
  s.description = 'Critical Path CSS'
  s.authors     = ['Michael Misshore']
  s.email       = 'mmisshore@gmail.com'
  s.homepage    = 'http://rubygems.org/gems/critical-path-css'
  s.license     = 'MIT'

  s.add_runtime_dependency 'phantomjs', ['~> 1.9.8.0']

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path = 'lib'
end