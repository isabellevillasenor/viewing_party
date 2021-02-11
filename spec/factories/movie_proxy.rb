FactoryBot.define do
  factory :movie_proxy do
    initialize_with {
      new({title: Faker::Movie.title,
      vote_average: rand(0..10.0).round(1),
      id: rand(1..800000),
      runtime: rand(5..200),
      overview: Faker::Movie.quote})
    }
  end
end
