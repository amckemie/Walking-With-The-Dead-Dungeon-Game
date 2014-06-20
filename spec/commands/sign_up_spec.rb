require 'spec_helper'

describe WWTD::SignUp do
  let(:player1) {WWTD.db.create_player(username: "Ashley", password: "thisiseightletters", description: "the best player ever!")}

  before(:each) do
    WWTD.db.clear_tables
  end

  it 'exists' do
    expect(WWTD::SignUp).to be_a(Class)
  end

  it 'returns an error message if a person does not enter a username' do
    result = WWTD::SignUp.new.run(username: nil, password: "thisiseightletters", description: "I stole your username!")
    binding.pry
  end

  it 'returns an error message if a person does not enter a password' do
  end

  it 'returns an error message if a person does not enter an 8 letter password' do
  end

  it "returns an error message if a player with that email already exists" do
    player1
    result = WWTD::SignUp.new.run(username: "Ashley", password: "thisiseightletters", description: "I stole your username!")
    expect(result[:success?]).to eq(false)
    expect(result[:error]).to eq("That username is already taken.")
  end

  it "returns a success message if the player is able to successfully sign up by entering a unique username" do
    result = WWTD::SignUp.new.run(username: "Ashley", password: "thisiseightletters", description: "BOOOYA")
    expect(result[:success?]).to eq(true)
    expect(result[:player]).to be_a(WWTD::PlayerNode)
    player = WWTD.db.get_player_by_username(result[:player].username)
    expect(player.username).to eq("Ashley")
    expect(result[:message]).to eq("Player successfully signed up.")
  end
end



