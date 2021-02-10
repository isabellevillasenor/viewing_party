require 'rails_helper'

RSpec.describe 'authorization' do
  describe 'does not allow a visitor to visit user pages' do
    it { visit dashboard_path }
    # it { visit new_party_path }

    after(:each) do
      expect(current_path).to eq(root_path)
      expect(page).to have_content("Please Log in or Create an Account")
    end
  end
end
