require 'json'
require 'open3'

module CriticalPathCss
  class CssFetcher
    GEM_ROOT = File.expand_path(File.join('..', '..'), File.dirname(__FILE__))

    def initialize(config)
      @config = config
    end

    def fetch
      @config.routes.map { |route| [route, css_for_route(route)] }.to_h
    end

    def fetch_route(route)
      css_for_route route
    end

    protected

    def css_for_route(route)
      options = {
        'url' => @config.base_url + route,
        'css' => @config.css_path,
        ## optional params
        # viewport dimensions
        'width' => 1300,
        'height' => 900,
        # CSS selectors to always include, e.g.:
        'forceInclude' => [
          #  '.keepMeEvenIfNotSeenInDom',
          #  '^\.regexWorksToo'
        ],
        # ms; abort critical CSS generation after this timeout
        'timeout' => 30000,
        # set to true to throw on CSS errors (will run faster if no errors)
        'strict' => false,
        # characters; strip out inline base64 encoded resources larger than this
        'maxEmbeddedBase64Length' => 1000,
        # specify which user agent string when loading the page
        'userAgent' => 'Penthouse Critical Path CSS Generator',
        # ms; render wait timeout before CSS processing starts (default: 100)
        'renderWaitTime' => 100,
        # set to false to load (external) JS (default: true)
        'blockJSRequests' => true,
        # see `phantomjs --help` for the list of all available options
        'phantomJsOptions' => {
          'ignore-ssl-errors' => true,
          'ssl-protocol' => 'tlsv1'
        },
        'customPageHeaders' => {
          # use if getting compression errors like 'Data corrupted':
          'Accept-Encoding' => 'identity'
        }
      }.merge(@config.penthouse_options)
      out, err, st = Dir.chdir(GEM_ROOT) do
        Open3.capture3('node', 'lib/fetch-css.js', JSON.dump(options))
      end
      if !st.exitstatus.zero? || out.empty? && !err.empty?
        STDOUT.puts out
        STDERR.puts err
        raise "Failed to get CSS for route #{route}\n" \
              "  with options=#{options.inspect}"
      end
      out
    end
  end
end
