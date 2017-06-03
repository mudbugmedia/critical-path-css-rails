# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'CssFetcher' do
  before :all do
    StaticFileServer.start
  end

  after :all do
    StaticFileServer.stop
  end

  it 'fetches css' do
    config = CriticalPathCss::Configuration.new(
      'base_url' => StaticFileServer.url,
      'css_path' => 'spec/fixtures/static/test.css',
      'routes' => ['/test.html']
    )
    fetcher = CriticalPathCss::CssFetcher.new(config)
    expect(fetcher.fetch).to(
      eq('/test.html' => "p {\n  color: red;\n}\n")
    )
  end
end
