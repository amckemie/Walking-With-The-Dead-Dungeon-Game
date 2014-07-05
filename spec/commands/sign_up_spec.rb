require 'spec_helper'

describe WWTD::SignUp do
  let(:db) {WWTD.db}
  let(:player)  {db.create_player(username: 'zombiekilla', password: 'eightletters', description: 'a zombie killing machine')}
  before(:each) do
    WWTD.db.clear_tables
    @sign_up = WWTD::SignUp.new
    @test_player = {username: 'zombiekilla', password: 'testingtesting', description: 'here'}
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {answer_phone: true})
    @room1 = db.create_room(name: 'Bedroom', description: 'test', quest_id: @quest.id, canE: false, start_new_quest: true)
    @char = db.create_character(name: 'bloody clown zombie', classification: 'zombie', description: 'a scary zombie', quest_id: @quest.id, room_id: @room1.id, strength: 20)
    @cell = db.create_item(classification: 'item',
                                name: 'Your cell phone',
                                description: "An iPhone that's been dropped nearly one too many times",
                                actions: 'answer, pick up, call',
                                room_id: @room1.id
                                )
    db.create_quest_item(item_id: @cell.id, room_id: @room1.id, quest_id: @quest.id)
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
    new_player = {username: "Ashley", password: "thisiseightletters", description: "BOOOYA"}
    result = @sign_up.run(new_player)
    expect(result.success?).to eq(true)
    expect(result.player).to be_a(WWTD::PlayerNode)
    player = WWTD.db.get_player_by_username(result.player.username)
    expect(player.username).to eq("Ashley")
    expect(result.message).to eq("Player successfully signed up.")
  end

  describe "setting up player's game upon successful sign up" do
    before(:each) do
      @result = @sign_up.run(@test_player)
    end

    it 'puts the player in the first room' do
      expect(@result.success?).to eq(true)
      expect(@result.player.room_id).to eq(@room1.id)
    end

    it 'adds a quest progress record for quest 1 to the table for the player' do
      quests = WWTD.db.get_player_quests(@result.player.id)
      expect(quests.count).to eq(1)
    end

    it 'creates all the playerRoom records for the game for that player' do
      expect(db.get_player_room(@result.player.id, @room1.id)).to_not be_nil
    end

    it 'adds records for the player in the questCharacters table' do
      quest_characters = WWTD.db.get_players_quest_characters(@result.player.id, @quest.id)
      expect(quest_characters.count).to eq(1)
    end

    it 'adds records for the player in the roomItems table' do
      room_items = WWTD.db.get_quest_items_left(@result.player.id, @quest.id)
      expect(room_items.count).to eq(1)
    end
  end
end



