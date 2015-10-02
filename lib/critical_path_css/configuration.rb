module CriticalPathCss
  class Configuration
    CONFIGURATION_FILENAME = 'critical_path_css.yml'

    def initialize
      @configurations = YAML.load_file(configuration_file_path)[Rails.env]
    end

    def routes
      @routes ||= @configurations['routes']
    end

    def base_url
      @base_url ||= @configurations['base_url']
    end

    private

    def configuration_file_path
      Rails.root.join('config', CONFIGURATION_FILENAME)
    end
  end
end
