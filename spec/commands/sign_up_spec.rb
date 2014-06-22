require 'spec_helper'

describe WWTD::SignUp do
  let(:player)  {WWTD.db.create_player(username: 'zombiekilla', password: 'eightletters', description: 'a zombie killing machine', room_id: 1)}
  before(:each) do
    WWTD.db.clear_tables
    @sign_up = WWTD::SignUp.new
    @test_player = {username: 'zombiekilla', password: 'testingtesting', description: 'here', room_id: 1}
  end

  it 'exists' do
    expect(WWTD::SignUp).to be_a(Class)
  end

  it 'returns an error message if a person does not enter a username' do
    @test_player[:username] = ''
    result = @sign_up.run(@test_player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_params)
    expect(result.reasons).to eq(username: ["can't be blank"])
  end

  it 'returns an error message if a person does not enter a password or enters one that is not long enough' do
    @test_player[:password] = nil
    result = @sign_up.run(@test_player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_params)
    expect(result.reasons).to eq(password: ["can't be blank", "is too short (minimum is 8 characters)"])
  end

  it 'returns an error message if a person does not enter a description' do
    @test_player[:description] = nil
    result = @sign_up.run(@test_player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_params)
    expect(result.reasons).to eq(description: ["can't be blank"])
  end

  it "returns an error message if a player with that email already exists" do
    player
    result = @sign_up.run(@test_player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_params)
    expect(result.reasons).to eq(username: ["is already taken"])
  end


  it "returns a success message if the player is able to successfully sign up by entering a unique username" do
    new_player = {username: "Ashley", password: "thisiseightletters", description: "BOOOYA", room_id: 1}
    result = @sign_up.run(new_player)
    expect(result.success?).to eq(true)
    expect(result.player).to be_a(WWTD::PlayerNode)
    player = WWTD.db.get_player_by_username(result.player.username)
    expect(player.username).to eq("Ashley")
    expect(result.message).to eq("Player successfully signed up.")
  end
end



