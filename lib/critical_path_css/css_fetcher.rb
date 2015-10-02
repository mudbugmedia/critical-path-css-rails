module CriticalPathCss
  class CssFetcher
    require 'phantomjs'
    require 'critical_path_css/configuration'

    PENTHOUSE_PATH = "#{File.dirname(__FILE__)}/../penthouse/penthouse.js"

    def initialize(main_css_relative_path)
      @main_css_path = "#{Rails.root}/public#{main_css_relative_path}"
      @config = Configuration.new
    end

    def fetch
      @config.routes.map { |route| [route, css_for_route(route)] }.to_h
    end

    private

    def css_for_route(route)
      Phantomjs.run(PENTHOUSE_PATH, @config.base_url + route, @main_css_path)
    end
  end
end
