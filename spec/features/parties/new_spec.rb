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
    @movie = build(:movie_proxy)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    allow_any_instance_of(ApplicationController).to receive(:movie).and_return(@movie)
  end

  it 'displays the party form, creates party and redirects to dashboard' do
    visit new_party_path

    expect(page).to have_text(@movie.title)

    expect(page).to have_field('party[party_duration]', with: @movie.runtime)
    expect(page).to have_field('party[date]', with: Date.today)
    expect(page).to have_field('party[time]')


    fill_in 'party[date]', with: Date.tomorrow.strftime('%Y-%m-%d')
    fill_in 'party[time]', with: '08:00 PM'

    within("#friend-#{@user2.id}") {check('party[friends][]')}
    within("#friend-#{@user3.id}") {check('party[friends][]')}

    click_button 'Create Party'

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content('2 Invitations Sent!')

    within(".parties") do
      expect(page).to have_content(@movie.title)
      expect(page).to have_content('Hosting')
    end
  end

  describe 'sad path' do
    it 'displays a flash message and renders the new view' do
      visit new_party_path

      fill_in 'party[party_duration]', with: 0
      click_button 'Create Party'

      expect(page).to have_content("Party duration must be greater than 0")
    end
  end
end
