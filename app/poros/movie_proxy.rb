class MovieProxy
  attr_reader :title,
              :vote_average,
              :id,
              :runtime,
              :overview

  def initialize(data)
    @title = data[:title]
    @vote_average = data[:vote_average]
    @id = data[:id]
    @runtime = data[:runtime] if data[:runtime]
    @genres = data[:genres] if data[:genres]
    @overview = data[:overview] if data[:overview]
  end

  def genres
    @genres.pluck(:name)
  end
end
