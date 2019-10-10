require "rails_helper"

describe "Manage Movies" do
  let(:current_account){ create(:account) }

  before(:each) do
    create(:address, account: current_account)
    login(current_account)
  end

  it "list movies now playing", vcr: "list-movies" do
    visit movies_path(mode: "now_playing")
    expect(page).to have_content("Joker")
  end

  it "display the info of a movie", vcr: "movie-detail" do
    visit movies_path(mode: "now_playing")

    within(".js-movie-475557") do #ID of the Joker
      click_link "Details"
    end

    expect(page).to have_link("Joaquin Phoenix")
  end
end
