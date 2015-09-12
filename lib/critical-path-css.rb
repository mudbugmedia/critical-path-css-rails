class CriticalPathCss
  require 'phantomjs'

  CACHE_NAMESPACE = 'critical-path-css'
  PENTHOUSE_PATH = "#{File.dirname(__FILE__)}/penthouse/penthouse.js"

  def self.generate (main_css_path, base_url, routes)
    full_main_css_path = "#{Rails.root.to_s}/public#{main_css_path}"

    routes.each do |route|
      css = Phantomjs.run(PENTHOUSE_PATH, base_url + route, full_main_css_path)
      Rails.cache.write(route, css, namespace: CACHE_NAMESPACE)
    end
  end

  def self.fetch (route)
    Rails.cache.read(route, namespace: CACHE_NAMESPACE) || ''
  end
end