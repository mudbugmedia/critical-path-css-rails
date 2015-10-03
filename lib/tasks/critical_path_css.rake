require 'critical_path_css_rails'

namespace :critical_path_css do
  desc 'Generate critical CSS for the routes defined'
  task generate: :environment do
    CriticalPathCss.generate
  end
end
