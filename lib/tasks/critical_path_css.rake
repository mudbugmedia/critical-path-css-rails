require 'critical-path-css'

namespace :critical_path_css do
  @base_url = Rails.env.production? ? 'http://example.com' : 'http://localhost:3000'
  @routes = %w{
    /
  }

  desc "Generate critical CSS for the routes defined"
  task :generate => :environment do
    @main_css_path = ActionController::Base.helpers.stylesheet_path('application.css').to_s

    CriticalPathCss.generate(@main_css_path, @base_url, @routes)
  end
end
