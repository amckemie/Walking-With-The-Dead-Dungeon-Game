require 'spec_helper'

describe WWTD::UseItem do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @room = db.create_room(name: 'Bedroom', description: 'test', quest_id: 1)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @room.id)
    @phone = db.create_item(classification: 'item',
                            name: 'phone',
                            description: "An iPhone that's been dropped nearly one too many times",
                            actions: 'answer, pick up, call',
                            room_id: bedroom.id
                            )
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {})
    db.create_room_item(player_id: @player.id, quest_id: @quest.id, room_id: @room.id, item_id: @jacket.id)
    WWTD.db.create_quest_progress(quest_id: @quest.id, player_id: @player.id, furthest_room_id: @room.id, data: @quest.data, complete: false)
  end

end
