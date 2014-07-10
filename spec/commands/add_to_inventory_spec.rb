require 'spec_helper'

describe WWTD::AddToInventory do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {answer_phone: true})
    @room1 = db.create_room(name: 'Bedroom', description: 'test', quest_id: @quest.id, canE: false, start_new_quest: true)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @room1.id)
    @cell = db.create_item(classification: 'item',
                                name: 'Your cell phone',
                                description: "An iPhone that's been dropped nearly one too many times",
                                actions: 'answer, call',
                                room_id: @room1.id
                                )
    db.create_quest_item(item_id: @cell.id, room_id: @room1.id, quest_id: @quest.id)
    WWTD.db.create_room_item(quest_id: @quest.id, player_id: @player.id, room_id: @cell.room_id, item_id: @cell.id)
    WWTD.db.create_quest_progress(quest_id: @quest.id, player_id: @player.id, furthest_room_id: @room1.id, data: @quest.data, complete: false)
  end

  it 'checks the players room id and the items rood id for a match. Returns success false if they dont' do
    updated_player = db.update_player(@player.id, room_id: 2)
    result = subject.run(updated_player, @cell)
    expect(result.success?).to eq(false)
    expect(result.error).to eq('That item is not in this room.')
  end

  it 'returns success true if the ids match' do
    result = subject.run(@player, @cell)
    expect(result.success?).to eq(true)
  end

  it 'adds the item to the players inventory' do
    before_inventory = db.get_player_inventory(@player.id)
    expect(before_inventory).to eq(nil)

    result = subject.run(@player, @cell)
    expect(result.success?).to eq(true)
    expect(result.message).to eq("Item picked up!")

    after_inventory = db.get_player_inventory(@player.id)
    expect(after_inventory.count).to eq(1)
  end

  it 'removes the item from the room items table' do
    before_room_items = db.get_player_room_items(@player.id, @room1.id)
    expect(before_room_items.count).to eq(1)

    result = subject.run(@player, @cell)
    expect(result.success?).to eq(true)

    after_room_items = db.get_player_room_items(@player.id, @room1.id)
    expect(after_room_items.count).to eq(0)
  end
end
