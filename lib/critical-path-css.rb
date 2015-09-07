class CriticalPathCss
  require 'phantomjs'

  def self.generate_css
    Phantomjs.run("#{penthouse_path} http://google.com google.css > critical-css-google.css")
  end

  private

  def penthouse_path
    'penthouse/penthouse.js'
  end
end