class Review
  attr_reader :author,
              :content,
              :id

  def initialize(data)
    @author = data[:author]
    @content = data[:content]
    @id = data[:id]
  end
end
