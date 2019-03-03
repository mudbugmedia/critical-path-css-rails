require 'spec_helper'

RSpec.describe 'ConfigLoader' do
  subject { CriticalPathCss::Rails::ConfigLoader.new }

  describe '#load' do
    before do
      allow(File).to receive(:read).and_return(config_file)
    end

    context 'when single css_path is specified' do
      let(:config_file) { file_fixture('config/single-css-path.yml').read }

      it 'sets css_paths with the lone path' do
        expect(subject.config['css_paths']).to eq ['/app/spec/internal/public/test.css']
      end
    end

    context 'when multiple css_paths are specified' do
      let(:config_file) { file_fixture('config/mutliple-css-paths.yml').read }

      it 'leaves css_paths to an array of paths' do
        expect(subject.config['css_paths']).to eq ['/app/spec/internal/public/test.css','/app/spec/internal/public/test2.css']
      end
    end

    context 'when no paths are specified' do
      let(:config_file) { file_fixture('config/no-paths-specified.yml').read }

      it 'sets css_paths with the lone manifest path' do
        expect(subject.config['css_paths']).to eq ['/stylesheets/application.css']
      end
    end

    context 'when single css_path and multiple css_paths are both specified' do
      let(:config_file) { file_fixture('config/paths-both-specified.yml').read }

      it 'raises an error' do
        expect { subject }.to raise_error LoadError, 'Cannot specify both css_path and css_paths'
      end
    end

    context 'when css_paths and routes are not the same length' do
      let(:config_file) { file_fixture('config/paths-and-routes-not-same-length.yml').read }

      it 'raises an error' do
        expect { subject }.to raise_error LoadError, 'Must specify css_paths for each route'
      end
    end
  end
end
