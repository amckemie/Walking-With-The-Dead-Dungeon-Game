require 'spec_helper'

describe WWTD::ShowInventory do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: 1)
  end

  it "returns an error message if the player has no items in their inventory" do
    result = subject.run(@player)
    expect(result.success?).to eq(false)
    expect(result.error).to eq("Ruh roh. You have no items with you. Might want to fix that...")
  end

  it 'returns a success message and the items in the players inventory if they have items' do
    cell = db.create_item(classification: 'item',
                          name: 'Your cell phone',
                          description: "An iPhone that's been dropped nearly one too many times",
                          actions: 'answer, call',
                          room_id: 1
                          )
    WWTD.db.create_room_item(quest_id: 1, player_id: @player.id, room_id: 1, item_id: cell.id)
    db.create_inventory(@player.id, 1, cell.id, 1)
    result = subject.run(@player)
    expect(result.success?).to eq(true)
    expect(result.message).to eq("Your cell phone")
  end
end
