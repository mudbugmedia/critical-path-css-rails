require 'critical_path_css_rails'

namespace :critical_path_css do
  desc 'Generate critical CSS for the routes defined'
  task generate: :environment do
    main_css_path = ActionController::Base.helpers.stylesheet_path('application.css').to_s

    CriticalPathCss.generate(main_css_path)
  end
end
