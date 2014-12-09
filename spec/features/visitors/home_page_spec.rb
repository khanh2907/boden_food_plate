# Feature: Home page
#   As a visitor
#   I want to visit a home page
#   So I can learn more about the website
feature 'Home page' do

  # Scenario: Visit the home page
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "Welcome"
  scenario 'visit the home page' do
    visit root_path
    expect(page).to have_content 'Mixtape crucifix kitsch hella blog PBR&B. Skateboard banh mi butcher normcore pug, 3 wolf moon seitan art party artisan narwhal swag organic Banksy DIY. Organic pork belly wayfarers fingerstache Shoreditch, deep v stumptown readymade. Crucifix Carles keytar stumptown pork belly, Tumblr single-origin coffee tofu art party Banksy Thundercats XOXO. Cred High Life VHS iPhone, pickled ethical banh mi Pinterest blog. Before they sold out asymmetrical Banksy, authentic retro cred paleo Schlitz. Cred sartorial PBR, fingerstache mumblecore 3 wolf moon gentrify vegan locavore.'
  end

end
