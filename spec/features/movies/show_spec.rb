require 'rails_helper'

describe 'Movies Show Page' do
  let(:movie) { build(:movie_proxy) }
  let(:cast) { [Actor.new({name: "Will Smith", character: "Capt. Steven Hiller"}),
                Actor.new({name: "Jeff Goldblum", character: "David Levinson"})] }
  let(:reviews) { [Review.new({author: "GeneSiskel", content: "Amazing!"}),
                  Review.new({author: "RogerEbert", content: "Explosive!"})] }

  before(:each) do
    allow(MoviesFacade).to receive(:movie_details).and_return(movie)
    allow(movie).to receive(:genres).and_return(["Action", "Adventure", "Science Fiction"])
    allow(MoviesFacade).to receive(:cast_details).and_return(cast)
    allow(MoviesFacade).to receive(:review_details).and_return(reviews)
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit movie_path(api_ref: movie.api_ref)
  end


  it 'displays the movie details' do
    expect(page).to have_content(movie.title)
    expect(page).to have_content("Vote Average: #{movie.vote_average}")
    expect(page).to have_content("Runtime: #{movie.runtime}")
    expect(page).to have_content("Genre(s): #{movie.genres.join(', ')}")
  end

  it 'has a section with summary' do
    within('#summary') do
      expect(page).to have_content(movie.overview)
    end
  end

  it 'displays a section with the cast' do
    within('#cast') do
      cast.each do |actor|
        expect(page).to have_content(actor.name)
        expect(page).to have_content(actor.character)
      end
    end
  end

  it 'has a section for reviews' do
    within('#reviews') do
      expect(page).to have_content("#{reviews.size} Reviews")
      reviews.each do |review|
        expect(page).to have_content(review.author)
        expect(page).to have_content(review.content)
      end
    end
  end

  it 'has a button to create a viewing party' do
    expect(page).to have_button('Create Viewing Party!')

    click_button

    expect(current_path).to eq(new_party_path)
  end
end
