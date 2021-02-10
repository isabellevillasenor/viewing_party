require 'rails_helper'

describe 'New Viewing Party Page' do
  # before :each do 
  #   visit new_party_path
  # end

  it 'displays the movie title with the default party duration set to movie runtime' do
    VCR.use_cassette('movie_details') do
      data = File.read('spec/fixtures/movie_details.json')
      movie_data = JSON.parse(data, symbolize_names: true)
      @movie = MovieProxy.new(movie_data)
      visit "/movies/#{@movie.id}"

      click_button 'Create Viewing Party!'
  
      expect(find_field(:title).value).to eq(@movie.title)
      expect(find_field(:party_duration).value).to eq(@movie.runtime.to_s)
    end 
  end

  it 'allows users to select date and start time' do
    VCR.use_cassette('movie_details') do
      data = File.read('spec/fixtures/movie_details.json')
      movie_data = JSON.parse(data, symbolize_names: true)
      @movie = MovieProxy.new(movie_data)
      visit "/movies/#{@movie.id}"

      click_button 'Create Viewing Party!'


      within("#party-date") do
        expect(find_field(:party_time).value).to eq(Date.today.strftime('%Y-%m-%d'))
      end

      within("#party-time") do
        fill_in :party_time, with: '08:00 PM'
        expect(find_field(:party_time).value).to eq('08:00 PM')
      end
    end
  end

  it 'allows users to select a check box for each friend to add to the viewing party' do

  end

  it 'allows users to create the party and be redirected to their dashboard and see the party with invited friends' do

  end
end