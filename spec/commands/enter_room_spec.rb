require 'spec_helper'

describe WWTD::EnterRoom do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {answer_phone: true})
    @room1 = db.create_room(name: 'Bedroom', description: 'test', quest_id: 0, canE: false, start_new_quest: true)
    @room2 = db.create_room(name: 'Kitchen', description: 'room with food', south: @room1.id, quest_id: @quest.id, start_new_quest: true)
    @room3 = db.create_room(name: 'New Room', description: 'eff these tests', east: @room1.id, quest_id: @quest.id)
    @locked_room = db.create_room(name: "secret room", description: "locked room", west: @room1.id, quest_id: @quest.id)
    @updated_room1 = db.update_room(@room1.id, north: @room2.id, east: @locked_room.id, west: @room3.id)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @updated_room1.id)
  end

  describe 'move to new room' do
    it 'returns success false and error message of direction not recognized if the dir is not N/E/S/W' do
      result = subject.run('test', @player)
      expect(result.success?).to eq(false)
      expect(result.error).to eq("Sorry, that is not a known direction. Which way do you want to go?")
    end

    it 'checks room for an available room in inputted direction and returns false if there is no room in that direction' do
      result = subject.run('south', @player)
      updated_player = db.update_player(@player.id, room_id: @room2.id)
      result2 = subject.run('NORTH', updated_player)
      result3 = subject.run('e', updated_player)
      result4 = subject.run('W', updated_player)

      expect(result.success?).to eq(false)
      expect(result2.success?).to eq(false)
      expect(result3.success?).to eq(false)
      expect(result4.success?).to eq(false)

      expect(result.error).to eq("Silly you. There is nothing there; You can't go that way")
      expect(result2.error).to eq("Silly you. There is nothing there; You can't go that way")
      expect(result3.error).to eq("Silly you. There is nothing there; You can't go that way")
      expect(result4.error).to eq("Silly you. There is nothing there; You can't go that way")
    end

    it 'checks the rooms can* direction attribute if there is a room in that direction and returns false if the attribute = false' do
      result = subject.run('east', @player)
      expect(result.success?).to eq(false)
      expect(result.error).to eq("Sorry, that direction is not currently accessible.")
    end

    it 'updates a players room id to the new room if there was a room and the can* attribute was true' do
      result = subject.run('north', @player)
      expect(result.success?).to eq(true)
      expect(result.player.room_id).to eq(@room2.id)
      expect(result.room.id).to eq(@room2.id)
    end
  end

  describe 'Check for new quest' do
    it "returns new_quest? true if the room is supposed to start a new quest" do
      result = subject.run('north', @player)
      expect(result.success?).to eq(true)
      expect(result.room.id).to eq(@room2.id)
      expect(result.start_new_quest?).to eq(true)
    end

    it "returns new_quest? false if the room is not supposed to start a new quest" do
      result = subject.run('west', @player)
      expect(result.success?).to eq(true)
      expect(result.room.id).to eq(@room3.id)
      expect(result.start_new_quest?).to eq(false)
    end
  end

  describe 'hedge case for starting the game' do
    it "updates a player's room_id to the 'first' room if the dir is start and they have no room_id" do
      player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player")
      result = subject.run('start', player)
      expect(result.success?).to eq(true)
      expect(result.room.id).to eq(@room1.id)
      expect(result.start_new_quest?).to eq(true)
    end
  end

  after(:each) do
    db.clear_tables
  end
end
