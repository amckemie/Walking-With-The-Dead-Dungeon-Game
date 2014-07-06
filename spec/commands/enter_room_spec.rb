require 'spec_helper'

describe WWTD::EnterRoom do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {answer_phone: true})
    @room1 = db.create_room(name: 'Bedroom', description: 'test', quest_id: @quest.id, canE: false, start_new_quest: true)
    @room2 = db.create_room(name: 'Kitchen', description: 'room with food', south: @room1.id, quest_id: @quest.id, start_new_quest: true)
    @room3 = db.create_room(name: 'New Room', description: 'eff these tests', east: @room1.id, quest_id: @quest.id)
    @locked_room = db.create_room(name: "secret room", description: "locked room", west: @room1.id, quest_id: @quest.id)
    @updated_room1 = db.update_room(@room1.id, north: @room2.id, east: @locked_room.id, west: @room3.id)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @updated_room1.id)
    @cell = db.create_item(classification: 'item',
                                name: 'Your cell phone',
                                description: "An iPhone that's been dropped nearly one too many times",
                                actions: 'answer, pick up, call',
                                room_id: @room1.id
                                )
    db.create_quest_item(item_id: @cell.id, room_id: @room1.id, quest_id: @quest.id)
    db.create_quest_progress(quest_id: @quest.id, player_id: @player.id, complete: false, furthest_room_id: @updated_room1.id, data: {answer_phone: true})
  end

  describe 'move to new room' do
    it 'checks room for an available room in inputted direction and returns false if there is no room in that direction' do
      result = subject.run('south', @player)
      updated_player = db.update_player(@player.id, room_id: @room2.id)
      result2 = subject.run('north', updated_player)
      result3 = subject.run('e', updated_player)
      result4 = subject.run('w', updated_player)

      expect(result.success?).to eq(false)
      expect(result2.success?).to eq(false)
      expect(result3.success?).to eq(false)
      expect(result4.success?).to eq(false)

      expect(result.error).to eq("Silly you. There is nothing there; You can't go that way")
      expect(result2.error).to eq("Silly you. There is nothing there; You can't go that way")
      expect(result3.error).to eq("Silly you. There is nothing there; You can't go that way")
      expect(result4.error).to eq("Silly you. There is nothing there; You can't go that way")
    end


    it 'updates a players room id to the new room if there is a room to move to' do
      result = subject.run('north', @player)
      expect(result.success?).to eq(true)
      expect(result.player.room_id).to eq(@room2.id)
    end

    it 'returns the player when move is successful' do
      result = subject.run('north', @player)
      expect(result.player).to_not be_nil
    end

    it 'updates the players quest progress to mark new room as furthest room if its the highest room # so far' do
      result = subject.run('north', @player)
      quest_progress = db.get_quest_progress(result.player.id, @quest.id)
      expect(result.player.room_id).to eq(@room2.id)
      expect(quest_progress.furthest_room_id).to eq(@room2.id)

      result2 = subject.run('south', result.player)
      quest_progress2 = db.get_quest_progress(result2.player.id, @quest.id)
      expect(result2.player.room_id).to eq(@room1.id)
      expect(quest_progress2.furthest_room_id).to eq(@room2.id)
    end

    it 'returns the new rooms description in the message key' do
      result = subject.run('north', @player)
      expect(result.message).to eq(@room2.description)
    end
  end

  # describe 'Check for new quest' do
  #   xit "returns new_quest? true if the room is supposed to start a new quest" do
  #     result = subject.run('north', @player)
  #     expect(result.success?).to eq(true)
  #     expect(result.room.id).to eq(@room2.id)
  #     expect(result.start_new_quest?).to eq(true)
  #   end

  #   xit "returns new_quest? false if the room is not supposed to start a new quest" do
  #     result = subject.run('west', @player)
  #     expect(result.success?).to eq(true)
  #     expect(result.room.id).to eq(@room3.id)
  #     expect(result.start_new_quest?).to eq(false)
  #   end
  # end

  after(:each) do
    db.clear_tables
  end
end
