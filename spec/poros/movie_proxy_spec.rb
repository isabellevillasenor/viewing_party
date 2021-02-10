require 'rails_helper'

describe MovieProxy do
  describe 'attributes' do
    let(:data) { {
        adult: false,
        backdrop_path: "/fQq1FWp1rC89xDrRMuyFJdFUdMd.jpg",
        genre_ids: [
            10749,
            35
        ],
        id: 761053,
        original_language: "en",
        original_title: "Gabriel's Inferno Part III",
        overview: "The final part of the film adaption of the erotic romance novel Gabriel's Inferno written by an anonymous Canadian author under the pen name Sylvain Reynard.",
        popularity: 36.755,
        poster_path: "/fYtHxTxlhzD4QWfEbrC1rypysSD.jpg",
        release_date: "2020-11-19",
        title: "Gabriel's Inferno Part III",
        video: false,
        vote_average: 9,
        vote_count: 659
        } }
    let(:movie_proxy) { MovieProxy.new(data) }

    it { expect(movie_proxy).to be_a(MovieProxy) }
    it { expect(movie_proxy).to have_attributes(title: data[:title],
      vote_average: data[:vote_average], api_ref: data[:id])}
  end

  describe 'detailed attributes' do
    let(:data) {{
        adult: false,
        backdrop_path: "/uw4SnKFZ453Gxmj5XR5Susj8TNo.jpg",
        belongs_to_collection: {
            id: 304378,
            name: "Independence Day Collection",
            poster_path: "/AuBMbv3gSAdTaEIzcUySRETIauY.jpg",
            backdrop_path: "/p7oqa94XgNGVMazXwR49QfyGgtx.jpg"
        },
        budget: 75000000,
        genres: [
            {
                id: 28,
                name: "Action"
            },
            {
                id: 12,
                name: "Adventure"
            },
            {
                id: 878,
                name: "Science Fiction"
            }
        ],
        homepage: "",
        id: 602,
        imdb_id: "tt0116629",
        original_language: "en",
        original_title: "Independence Day",
        overview: "On July 2, a giant alien mothership enters orbit around Earth and deploys several dozen saucer-shaped 'destroyer' spacecraft that quickly lay waste to major cities around the planet. On July 3, the United States conducts a coordinated counterattack that fails. On July 4, a plan is devised to gain access to the interior of the alien mothership in space, in order to plant a nuclear missile.",
        popularity: 50.84,
        poster_path: "/2e5t7edZcGcE7IQhr3hbdrJudUW.jpg",
        production_companies: [
            {
                id: 25,
                logo_path: "/qZCc1lty5FzX30aOCVRBLzaVmcp.png",
                name: "20th Century Fox",
                origin_country: "US"
            },
            {
                id: 347,
                logo_path: nil,
                name: "Centropolis Entertainment",
                origin_country: ""
            }
        ],
        production_countries: [
            {
                iso_3166_1: "US",
                name: "United States of America"
            }
        ],
        release_date: "1996-06-25",
        revenue: 817400891,
        runtime: 145,
        spoken_languages: [
            {
                english_name: "English",
                iso_639_1: "en",
                name: "English"
            }
        ],
        status: "Released",
        tagline: "Earth. Take a good look. It might be your last.",
        title: "Independence Day",
        video: false,
        vote_average: 6.8,
        vote_count: 7068
    }}
    let(:movie_proxy) { MovieProxy.new(data) }

    it { expect(movie_proxy).to be_a(MovieProxy) }
    it { expect(movie_proxy).to have_attributes(title: data[:title],
      vote_average: data[:vote_average], api_ref: data[:id], runtime: data[:runtime], overview: data[:overview], poster_path: data[:poster_path])}
  end
end
