require 'spec_helper.rb'

RSpec.describe 'generate and fetch the critical css' do
  before do
    CriticalPathCss.generate_all
  end

  context 'on the root page' do
    let(:route) { '/' }

    it 'displays the correct critical CSS' do
      visit route
      expect(page).to have_content 'p{color:red}'
    end
  end
end
