require 'rails_helper'

describe 'New Viewing Party Page' do
  before :each do
    @user1 = create :user
    @user2 = create :user
    @user3 = create :user
    @user4 = create :user

    create(:friendship, user: @user1, friend: @user2, status: 1)
    create(:friendship, user: @user1, friend: @user3, status: 1)
    create(:friendship, user: @user1, friend: @user4, status: 1)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  end

  it 'displays the party form, creates party and redirects to dashboard' do
    VCR.use_cassette('movie_details') do
      data = File.read('spec/fixtures/movie_details.json')
      movie_data = JSON.parse(data, symbolize_names: true)
      @movie = MovieProxy.new(movie_data)
      visit movie_path(api_ref: @movie.api_ref)

      click_button 'Create Viewing Party!'
      
      expect(find_field('party[title]').value).to eq(@movie.title)
      expect(find_field('party[party_duration]').value).to eq(@movie.runtime.to_s)

      fill_in 'party[date]', with: Date.tomorrow.strftime('%Y-%m-%d')
      expect(find_field('party[date]').value).to eq(Date.tomorrow.strftime('%Y-%m-%d'))

      fill_in 'party[time]', with: '08:00 PM'
      expect(find_field('party[time]').value).to eq('08:00 PM')

      find(:css, "#party_invitations_#{@user2.id}[value='#{@user2.id}']").set(true)
      find(:css, "#party_invitations_#{@user3.id}[value='#{@user3.id}']").set(true)

      click_button 'Create Party'

      expect(current_path).to eq(dashboard_path)

      within(".parties") do
        expect(page).to have_content(@movie.title)
        expect(page).to have_content('Hosting')
      end
    end
  end
end
