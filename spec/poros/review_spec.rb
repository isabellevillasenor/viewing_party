require 'rails_helper'

describe Review do
  it 'exists' do
    data = {
              author: "Gimly",
              author_details: {
                  name: "Gimly",
                  username: "Ruuz",
                  avatar_path: "/xUObnJSvHrFPsIpoDmb1jiQZLq7.jpg",
                  rating: 7.0
                  },
              content: "It's true I liked it less than perhaps the vast majority of _Spider-Verse's_ audience, but this was still great, the animation enamouring, and the depth of its story and reference totally engaging. Not to me the best Spider-Man movie as many have said, (that honour still goes to _Homecoming_) but a blast all the same.\r\n\r\n_Final rating:★★★½ - I really liked it. Would strongly recommend you give it your time._",
              created_at: "2019-02-19T03:38:58.950Z",
              id: "5c6b7a529251412fc40c2bb0",
              updated_at: "2019-03-04T20:52:01.463Z",
              url: "https://www.themoviedb.org/review/5c6b7a529251412fc40c2bb0"
              }
    review = Review.new(data)

    expect(review).to be_a Review
    expect(review).to have_attributes(author: data[:author], content: data[:content])
  end
end
