require 'erb'
module CriticalPathCss
  class Configuration
    def initialize(config)
      @config = config
    end

    def base_url
      @config['base_url']
    end

    def css_paths
      @config['css_paths']
    end

    def manifest_name
      @config['manifest_name']
    end

    def routes
      @config['routes']
    end

    def penthouse_options
      @config['penthouse_options'] || {}
    end
  end
end
