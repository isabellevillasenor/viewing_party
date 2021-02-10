require 'rails_helper'

describe MovieProxy do
  before :each do
    data = {
      "adult": false,
      "backdrop_path": "/fQq1FWp1rC89xDrRMuyFJdFUdMd.jpg",
      "genre_ids": [
          10749,
          35
      ],
      "id": 761053,
      "original_language": "en",
      "original_title": "Gabriel's Inferno Part III",
      "overview": "The final part of the film adaption of the erotic romance novel Gabriel's Inferno written by an anonymous Canadian author under the pen name Sylvain Reynard.",
      "popularity": 36.755,
      "poster_path": "/fYtHxTxlhzD4QWfEbrC1rypysSD.jpg",
      "release_date": "2020-11-19",
      "title": "Gabriel's Inferno Part III",
      "video": false,
      "vote_average": 9,
      "vote_count": 659
    }
    @movie_proxy = MovieProxy.new(data)
  end

  describe 'attributes' do
    it { expect(@movie_proxy.title).to eq("Gabriel's Inferno Part III") }
    it { expect(@movie_proxy.vote_average).to eq(9) }
    it { expect(@movie_proxy.api_ref).to eq(761053) }
  end
end
