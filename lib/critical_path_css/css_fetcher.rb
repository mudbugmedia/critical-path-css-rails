module CriticalPathCss
  class CssFetcher
    require 'phantomjs'
    require 'critical_path_css/configuration'

    PENTHOUSE_PATH = "#{File.dirname(__FILE__)}/../penthouse/penthouse.js"

    def initialize
      @config = Configuration.new
    end

    def fetch
      @config.routes.map { |route| [route, css_for_route(route)] }.to_h
    end

    def fetch_route(route)
      css_for_route route
    end

    protected

    def css_for_route(route)
      url = @config.base_url + route

      Phantomjs.run(
        '--ignore-ssl-errors=true',
        '--ssl-protocol=tlsv1',
        PENTHOUSE_PATH,
        url,
        @config.css_path
      )
    end
  end
end
