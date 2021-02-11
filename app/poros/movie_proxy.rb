class MovieProxy
  attr_reader :title,
              :vote_average,
              :api_ref,
              :runtime,
              :overview,
              :poster_path

  def initialize(data)
    @title = data[:title]
    @vote_average = data[:vote_average]
    @api_ref = data[:id]
    @runtime = data[:runtime]
    @genres = data[:genres]
    @overview = data[:overview]
    @poster_path = data[:poster_path]
  end

  def genres
    @genres.pluck(:name)
  end
end
