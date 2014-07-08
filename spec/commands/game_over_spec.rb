require 'spec_helper'

describe WWTD::GameOver do
  let(:db) {WWTD.db}
  let(:kitchen) {db.create_room(name: 'kitchen', quest_id: 1, description: 'a bright sunny room with food')}
  let(:qp) {WWTD.db.create_quest_progress(quest_id: 1, player_id: player.id, furthest_room_id: kitchen.id, data: {first_completed_action: 'snooze'}, complete: false)}
  let(:player) {db.create_player(username: 'zombiekilla', password: 'eightletters', description: 'a zombie killing machine', room_id: kitchen.id)}
  let(:item_1) {db.create_item(name: 'apple', description: "yummy red apple", classification: 'item', actions: 'take, eat', room_id: kitchen.id)}
  let(:room_item1) {db.create_room_item(player_id: player_1.id, quest_id: 1, room_id: kitchen.id, item_id: item_1.id)}
  let(:room_item2) {db.create_room_item(player_id: player_1.id, quest_id: 1, room_id: kitchen.id, item_id: 2, parent_item_id: item_1.id)}
  let(:inventory_item) {db.create_inventory(player.id, 1, 1, 1)}
  let(:zombie_1) {db.create_character(name: 'bloody clown zombie', classification: 'zombie', description: 'a scary zombie', quest_id: 1, room_id: kitchen.id, strength: 20)}
  let(:character_1) {db.create_character(name: 'Susie', description: "best friend", classification: 'person', quest_id: 1, room_id: kitchen.id)}
  let(:quest_character1) {db.create_quest_character(player_id: player.id, character_id: character_1.id, quest_id: 1, room_id: kitchen.id)}
  let(:quest_character2) {db.create_quest_character(player_id: player.id, character_id: zombie_1.id, quest_id: 1, room_id: kitchen.id)}
  let(:player_room) {db.create_player_room(player_id: player.id, room_id: kitchen.id, description: kitchen.description, quest_id: 1, canN: false)}

  before(:each) do
    db.clear_tables
  end

  it 'deletes all the players quest_progress records' do
    qp
    subject.run(player)
    expect(db.get_player_quests(player.id)).to eq(nil)
  end

  xit 'deletes all of a players rooms' do
  end

  xit 'deletes all of a players room items' do
  end

  xit 'deletes all of a players questCharacters' do
  end

  xit 'deletes all of a players inventory' do
  end

  xit 'deletes everything' do
  end

  xit 'starts the player over from the place of sign up' do
  end

  xit 'returns the new player in the first room' do
    result = subject.run(player)
    expect(result.player.id).to eq(player.id)
  end

end
