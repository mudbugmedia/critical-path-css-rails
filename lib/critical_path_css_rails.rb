module CriticalPathCss
  require 'phantomjs'

  CACHE_NAMESPACE = 'critical-path-css'
  PENTHOUSE_PATH  = "#{File.dirname(__FILE__)}/penthouse/penthouse.js"

  def self.generate(main_css_path)
    full_main_css_path = "#{Rails.root}/public#{main_css_path}"
    config = CriticalPathCss::Configuration.new(Rails.root, Rails.env)

    config.routes.each do |route|
      css = Phantomjs.run(PENTHOUSE_PATH, config.base_url + route, full_main_css_path)

      Rails.cache.write(route, css, namespace: CACHE_NAMESPACE)
    end
  end

  def self.fetch(route)
    Rails.cache.read(route, namespace: CACHE_NAMESPACE) || ''
  end
end
