module CriticalPathCss
  require 'critical_path_css/css_fetcher'

  CACHE_NAMESPACE = 'critical-path-css'

  def self.generate(main_css_relative_path)
    CssFetcher.new(main_css_relative_path).fetch.each do |route, css|
      Rails.cache.write(route, css, namespace: CACHE_NAMESPACE)
    end
  end

  def self.fetch(route)
    Rails.cache.read(route, namespace: CACHE_NAMESPACE) || ''
  end
end
