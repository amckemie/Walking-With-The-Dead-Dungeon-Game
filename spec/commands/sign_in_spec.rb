require 'spec_helper'

describe 'WWTD::SignIn' do
  let(:player) {WWTD::SignUp.new.run(username: 'zombiekilla', password: 'eightletters', description: 'a zombie killing machine', room_id: 1).player}
  before(:each) do
    WWTD.db.clear_tables
    @sign_in = WWTD::SignIn.new
    @test_player = {username: 'zombiekilla', password: 'testingtesting'}
  end

  it 'exists' do
    expect(WWTD::SignIn).to be_a(Class)
  end

  it 'returns an error if no username is entered' do
    @test_player[:username] = ''
    result = @sign_in.run(@test_player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_params)
    expect(result.reasons).to eq(username: ["can't be blank"])
  end

  it 'returns an error if no password is entered or if the entered password is less than 8 letters' do
    @test_player[:password] = nil
    result = @sign_in.run(@test_player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_params)
    expect(result.reasons).to eq(password: ["can't be blank", "is too short (minimum is 8 characters)"])
  end

  it 'returns an error if the username is not in the database' do
    result = @sign_in.run(@test_player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_username)
    expect(result.reasons).to eq(username: ["username not found"])
  end

  it 'returns an error if the password does not match the username' do
    player
    result = @sign_in.run(@test_player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_password)
    expect(result.reasons).to eq(password: ["incorrect password"])
  end

  it 'returns a success message if the person is signed in' do
    player
    @test_player[:password] = "eightletters"
    result = @sign_in.run(@test_player)
    expect(result.success?).to eq(true)
    expect(result.player.class).to eq(WWTD::PlayerNode)
    retrieved_player = WWTD.db.get_player_by_username(result.player.username)
    expect(retrieved_player.username).to eq("zombiekilla")
    expect(result.message).to eq("Player successfully signed in.")
  end
end
