require 'spec_helper'

describe WWTD::GameOver do
  let(:db) {WWTD.db}

  before(:each) do
    db.clear_tables
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {first_completed_action: nil})
    @kitchen = db.create_room(name: 'kitchen', quest_id: @quest.id, description: 'a bright sunny room with food', start_new_quest: true)
    @player = db.create_player(username: 'zombiekilla', password: 'eightletters', description: 'a zombie killing machine', room_id: @kitchen.id)
    @qp = WWTD.db.create_quest_progress(quest_id: 1, player_id: @player.id, furthest_room_id: @kitchen.id, data: {first_completed_action: 'snooze'}, complete: false)
    @item_1 = db.create_item(name: 'apple', description: "yummy red apple", classification: 'item', actions: 'take, eat', room_id: @kitchen.id)
    @room_item1 = db.create_room_item(player_id: @player.id, quest_id: @quest.id, room_id: @kitchen.id, item_id: @item_1.id)
    @room_item2 = db.create_room_item(player_id: @player.id, quest_id:  @quest.id, room_id: @kitchen.id, item_id: 2, parent_item_id: @item_1.id)
    @inventory_item = db.create_inventory(@player.id, @kitchen.id, @item_1.id,  @quest.id)
    @zombie_1 = db.create_character(name: 'bloody clown zombie', classification: 'zombie', description: 'a scary zombie', quest_id:  @quest.id, room_id: @kitchen.id, strength: 20)
    @character_1 = db.create_character(name: 'Susie', description: "best friend", classification: 'person', quest_id:  @quest.id, room_id: @kitchen.id)
    @quest_character1 = db.create_quest_character(player_id: @player.id, character_id: @character_1.id, quest_id:  @quest.id, room_id: @kitchen.id)
    @quest_character2 = db.create_quest_character(player_id: @player.id, character_id: @zombie_1.id, quest_id:  @quest.id, room_id: @kitchen.id)
    @player_room = db.create_player_room(player_id: @player.id, room_id: @kitchen.id, description: @kitchen.description, quest_id:  @quest.id, canN: false)
    db.create_quest_item(item_id: @item_1.id, room_id: @kitchen.id, quest_id: @quest.id)
  end

  it 'deletes all the players quest_progress, playerRooms, questcharacters, and inventory records. It starts player over' do
    subject.run(@player,  @quest.id)
    expect((db.get_quest_progress(@player.id, @quest.id)).data['first_completed_action']).to eq(nil)
    expect(db.get_all_player_rooms(@player.id)).to_not be_nil
    expect(db.get_players_quest_characters(@player.id, @quest.id)).to_not be_nil
    expect((db.get_player_inventory(@player.id)).count).to eq(1)
  end

  it 'returns the new player in the first room' do
    result = subject.run(@player, @quest.id)
    expect(result.player.id).to eq(@player.id)
  end
end
