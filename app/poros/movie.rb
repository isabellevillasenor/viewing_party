class MovieDetails
  attr_reader :title,
              :vote_average,
              :genre,
              :runtime,
              :overview,
              # :cast_name,
              # :review,
              # :reviewer_name

  def initialize(data)
    @title = data[:title]
    @vote_average = data[:vote_average]
    @genre = data[:genre]
    @runtime = data[:runtime]
    @overview = data[:overview]
    # @cast_name = data[:cast][:name]
    # @review = data[:results][:content]
    # @reviewer_name = data[:results][:author]
  end
end