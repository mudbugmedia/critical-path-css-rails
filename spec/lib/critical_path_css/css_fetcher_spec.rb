require 'spec_helper'

RSpec.describe 'CssFetcher' do
  subject { CriticalPathCss::CssFetcher.new(config) }

  let(:base_url) { 'http://0.0.0.0:9292' }
  let(:response) { ['foo','', OpenStruct.new(exitstatus: 0)] }
  let(:routes)   { ['/', '/new_route'] }
  let(:config) do
    OpenStruct.new(
      base_url: base_url,
      css_path: css_path,
      css_paths: css_paths,
      penthouse_options: {},
      routes: routes
    )
  end

  describe '#fetch_route' do
    context 'when a single css_path is configured' do
      let(:css_path) { '/test.css' }
      let(:css_paths) { [] }

      it 'generates css for the single route' do
        expect(Open3).to receive(:capture3) do |arg1, arg2, arg3|
          options = JSON.parse(arg3)

          expect(options['css']).to eq '/test.css'
        end.once.and_return(response)

        subject.fetch_route(routes.first)
      end
    end
  end

  describe '#fetch' do
    context 'when a single css_path is configured' do
      let(:css_path) { '/test.css' }
      let(:css_paths) { [] }

      it 'generates css for each route from the same file' do
        expect(Open3).to receive(:capture3) do |arg1, arg2, arg3|
          options = JSON.parse(arg3)

          expect(options['css']).to eq '/test.css'
        end.twice.and_return(response)

        subject.fetch
      end
    end

    context 'when multiple css_paths are configured' do
      let(:css_path) { '' }
      let(:css_paths) { ['/test.css', '/test2.css'] }

      it 'generates css for each route from the respective file' do
        expect(Open3).to receive(:capture3) do |arg1, arg2, arg3|
          options = JSON.parse(arg3)

          css_paths.each_with_index do |path, index|
            expect(options['css']).to eq path if options['url'] == "#{base_url}/#{routes[index]}"
          end
        end.twice.and_return(response)

        subject.fetch
      end
    end

    context 'when same css file applies to multiple routes' do
      let(:css_path) { '' }
      let(:css_paths) { ['/test.css', '/test2.css', '/test.css'] }
      let(:routes) { ['/', '/new_route', '/newer_route'] }

      it 'generates css for each route from the respective file' do
        expect(Open3).to receive(:capture3) do |arg1, arg2, arg3|
          options = JSON.parse(arg3)

          css_paths.each_with_index do |path, index|
            expect(options['css']).to eq path if options['url'] == "#{base_url}/#{routes[index]}"
          end
        end.thrice.and_return(response)

        subject.fetch
      end
    end
  end
end
