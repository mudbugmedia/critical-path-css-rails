require 'spec_helper'

RSpec.describe 'ConfigLoader' do
  let(:subject) { CriticalPathCss::Rails::ConfigLoader.new }
  describe '#load' do
    before do
      allow(File).to receive(:read).and_return(config_file)
    end

    context 'when single css_path is specified' do
      let(:config_file) {
        <<~CONFIG
          defaults: &defaults
            base_url: http://0.0.0.0:9292
            css_path: /test.css
            routes:
              - /

          development:
            <<: *defaults

          test:
            <<: *defaults
        CONFIG
      }

      it 'sets css_path with the path' do
        config = subject.load

        expect(config['css_path']).to eq '/app/spec/internal/public/test.css'
      end

      it 'leaves css_paths empty' do
        config = subject.load

        expect(config['css_paths']).to eq []
      end
    end

    context 'when multiple css_paths are specified' do
      let(:config_file) {
        <<~CONFIG
          defaults: &defaults
            base_url: http://0.0.0.0:9292
            css_paths:
              - /test.css
              - /test2.css
            routes:
              - /
              - /new_route

          development:
            <<: *defaults

          test:
            <<: *defaults
        CONFIG
      }

      it 'sets css_path to empty string' do
        config = subject.load

        expect(config['css_path']).to eq ''
      end

      it 'leaves css_paths to an array of paths' do
        config = subject.load

        expect(config['css_paths']).to eq ['/app/spec/internal/public/test.css','/app/spec/internal/public/test2.css']
      end
    end

    context 'when single css_path and multiple css_paths are both specified' do
      let(:config_file) {
        <<~CONFIG
          defaults: &defaults
            base_url: http://0.0.0.0:9292
            css_path: /test.css
            css_paths:
              - /test.css
              - /test2.css
            routes:
              - /
              - /new_route

          development:
            <<: *defaults

          test:
            <<: *defaults
        CONFIG
      }

      it 'raises an error' do
        expect { subject.load }.to raise_error LoadError, 'Cannot specify both css_path and css_paths'
      end
    end

    context 'when css_paths and routes are not the same length' do
      let(:config_file) {
        <<~CONFIG
          defaults: &defaults
            base_url: http://0.0.0.0:9292
            css_paths:
              - /test.css
              - /test2.css
            routes:
              - /
              - /new_route
              - /newer_route

          development:
            <<: *defaults

          test:
            <<: *defaults
        CONFIG
      }

      it 'raises an error' do
        expect { subject.load }.to raise_error LoadError, 'Must specify css_paths for each route'
      end
    end
  end
end
