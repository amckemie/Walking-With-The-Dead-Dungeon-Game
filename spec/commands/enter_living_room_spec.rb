require 'spec_helper'

describe WWTD::EnterLivingRoom do
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

  describe 'first time entering' do
    it 'updates a players quest_progress to state true for entered living ' do
    end

    xit 'checks the players first action and if not answer phone, player dies' do
    end

    xit 'updates a players status to dead true if the first action is not answer phone' do
    end
  end
end
    # xit 'returns that the player died from a zombie attack if the first action is not answer phone' do
    #   living_room = db.create_room(name: "Player's Living Room", description: "locked room", west: @room1.id, quest_id: @quest.id)
    #   @updated_room1 = db.update_room(@room1.id, north: @room2.id, east: @locked_room.id, west: @room3.id)
    #   result = subject.run
    # end
