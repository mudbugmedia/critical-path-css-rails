module CriticalPathCss
  module Rails
    class ConfigLoader
      CONFIGURATION_FILENAME = 'critical_path_css.yml'.freeze

      def initialize
        validate_css_paths
        format_css_paths
      end

      def config
        @config ||= YAML.safe_load(ERB.new(File.read(configuration_file_path)).result, [], [], true)[::Rails.env]
      end

      private

      def configuration_file_path
        @configuration_file_path ||= ::Rails.root.join('config', CONFIGURATION_FILENAME)
      end

      def format_css_paths
        config['css_paths'] = [config['css_path']] if config['css_path']

        if config['css_paths']
          config['css_paths'].map! { |path| format_path(path) }
        else
          config['css_paths'] = [ActionController::Base.helpers.stylesheet_path(config['manifest_name'], host: '')]
        end
      end

      def format_path(path)
        "#{::Rails.root}/public#{path}"
      end

      def validate_css_paths
        if config['css_path'] && config['css_paths']
          raise LoadError, 'Cannot specify both css_path and css_paths'
        elsif config['css_paths'] && config['css_paths'].length != config['routes'].length
          raise LoadError, 'Must specify css_paths for each route'
        end
      end
    end
  end
end
