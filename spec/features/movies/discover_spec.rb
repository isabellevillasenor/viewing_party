require 'rails_helper'

describe 'movies discover page' do
  before :each do
    json_response = File.read('spec/fixtures/top_movies.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['TMDB_API_KEY']}").
    to_return(status: 200, body: json_response)

    json_response = File.read('spec/fixtures/top_movies.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['TMDB_API_KEY']}&page=2").
    to_return(status: 200, body: json_response)

    @query = 'phoenix'
    json_response = File.read('spec/fixtures/movie_search.json')
    stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{ENV['TMDB_API_KEY']}&query=#{@query}").
    to_return(status: 200, body: json_response)

    json_response = File.read('spec/fixtures/movie_search.json')
    stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{ENV['TMDB_API_KEY']}&query=#{@query}&page=2").
    to_return(status: 200, body: json_response)
  end

  it 'has a Find Top Rated Movies button that redirects to the movies index page' do
    visit discover_path

    click_button 'Find Top Rated Movies'
    expect(current_path).to eq(movies_path)
  end

  it 'has a search by movie title field with a button to Find Movies that redirects to movies index page' do
    visit discover_path

    expect(page).to have_field(:title, placeholder: 'Search by movie title')

    fill_in :title, with: @query
    click_button 'Find Movies'
    expect(current_path).to eq(movies_path)
  end
end
