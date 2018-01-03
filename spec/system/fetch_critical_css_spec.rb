require 'spec_helper.rb'

RSpec.describe 'fetching the critical css' do
  before do
    CriticalPathCss.generate_all
  end

  context 'on the root page' do
    let(:route) { '/' }

    it 'displays the correct critical CSS' do
      visit route
      expect(page).to have_content 'color: red;'
    end
  end
end
