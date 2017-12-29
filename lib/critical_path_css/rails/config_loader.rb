module CriticalPathCss
  module Rails
    class ConfigLoader
      CONFIGURATION_FILENAME = 'critical_path_css.yml'.freeze

      def load
        config = YAML.safe_load(ERB.new(File.read(configuration_file_path)).result)[::Rails.env]
        config['css_path'] = "#{::Rails.root}/public" + (
            config['css_path'] ||
              ActionController::Base.helpers.stylesheet_path(
                config['manifest_name'], host: ''
              )
        )
        config
      end

      private

      def configuration_file_path
        @configuration_file_path ||= ::Rails.root.join('config', CONFIGURATION_FILENAME)
      end
    end
  end
end
