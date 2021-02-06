RSpec.configure do |config|
  config.before :each do
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
end
