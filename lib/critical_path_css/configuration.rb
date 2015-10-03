module CriticalPathCss
  class Configuration
    CONFIGURATION_FILENAME = 'critical_path_css.yml'

    def initialize
      @configurations = YAML.load_file(configuration_file_path)[Rails.env]
    end

    def base_url
      @configurations['base_url']
    end

    def css_path
      @css_path ||= begin
        relative_path = @configurations['css_path'] || manifest_path
        "#{Rails.root}/public#{relative_path}"
      end
    end

    def manifest_name
      @configurations['manifest_name']
    end

    def routes
      @configurations['routes']
    end

    private

    def configuration_file_path
      @configuration_file_path ||= Rails.root.join('config', CONFIGURATION_FILENAME)
    end

    def manifest_path
      @manifest_path ||= ActionController::Base.helpers.stylesheet_path(manifest_name)
    end
  end
end
