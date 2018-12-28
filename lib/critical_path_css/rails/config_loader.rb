module CriticalPathCss
  module Rails
    class ConfigLoader
      CONFIGURATION_FILENAME = 'critical_path_css.yml'.freeze

      def load
        config = YAML.safe_load(ERB.new(File.read(configuration_file_path)).result, [], [], true)[::Rails.env]
        validate_css_path config
        if config['css_path']
          config['css_path'] = "#{::Rails.root}/public" + (
            config['css_path'] ||
              ActionController::Base.helpers.stylesheet_path(
                config['manifest_name'], host: ''
              )
          )
          config['css_paths'] = []
        else
          config['css_path'] = ''
          config['css_paths'] = config['css_paths'].collect { |path| "#{::Rails.root}/public#{path}" }
        end
        config
      end

      private

      def configuration_file_path
        @configuration_file_path ||= ::Rails.root.join('config', CONFIGURATION_FILENAME)
      end

      def validate_css_path(config)
        if config['css_path'] && config['css_paths']
          raise LoadError, 'Cannot specify both css_path and css_paths'
        elsif config['css_paths'] && config['css_paths'].length != config['routes'].length
          raise LoadError, 'Must specify css_paths for each route'
        end
      end
    end
  end
end
