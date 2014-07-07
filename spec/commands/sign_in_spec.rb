require 'spec_helper'

describe 'WWTD::SignIn' do
  before(:each) do
    WWTD.db.clear_tables
    quest1 = WWTD.db.create_quest(name: 'Quest 1', data: {answer_phone: nil, first_completed_action: nil})
    bedroom = WWTD.db.create_room(name: "Your Bedroom",
                    description: "It's a cozy room that is relatively small. Your dresser is in the far corner with a jacket tossed on top of it. There's a bedstand next to your bed with a few pictures on it, including one of you and your good friend Susie.",
                    canS: false,
                    canE: false,
                    quest_id: quest1.id,
                    start_new_quest: true
                    )
    @phone = WWTD.db.create_item(classification: 'item',
                            name: 'phone',
                            description: "An iPhone that's been dropped nearly one too many times",
                            actions: 'answer, pick up, call',
                            room_id: bedroom.id
                            )
    @player = WWTD::SignUp.new.run(username: 'zombiekilla', password: 'eightletters', description: 'a zombie killing machine')
    @sign_in = WWTD::SignIn.new
  end

  it 'exists' do
    expect(WWTD::SignIn).to be_a(Class)
  end

  it 'returns an error if no username is entered' do
    test_player = {password: 'testingtesting'}
    result = @sign_in.run(test_player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_params)
    expect(result.reasons).to eq(username: ["can't be blank"])
  end

  it 'returns an error if no password is entered or if the entered password is less than 8 letters' do
    test_player = {username: 'zombiekilla'}
    result = @sign_in.run(test_player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_params)
    expect(result.reasons).to eq(password: ["can't be blank", "is too short (minimum is 8 characters)"])
  end

  it 'returns an error if the username is not in the database' do
    result = @sign_in.run(username: 'ashley', password: 'testpassword')
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_username)
    expect(result.reasons).to eq(username: ["username not found"])
  end

  it 'returns an error if the password does not match the username' do
    result = @sign_in.run(username: 'zombiekilla', password: 'testingtesting')
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:invalid_password)
    expect(result.reasons).to eq(password: ["incorrect password"])
  end

  it 'returns a success message if the person is signed in' do
    result = @sign_in.run(username: 'zombiekilla', password: "eightletters")
    expect(result.success?).to eq(true)
    expect(result.player.class).to eq(WWTD::PlayerNode)
    retrieved_player = WWTD.db.get_player_by_username(result.player.username)
    expect(retrieved_player.username).to eq("zombiekilla")
    expect(result.message).to eq("Player successfully signed in.")
  end
end
