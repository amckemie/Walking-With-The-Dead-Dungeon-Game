require 'spec_helper'

describe WWTD::UserAction do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @room = db.create_room(name: 'Bedroom', description: 'test', quest_id: 1)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @room.id)
  end

  describe 'where am i' do
    it 'returns the current rooms name and player' do
      result = subject.run(@player, 'where am i')
      expect(result.message).to eq("You are currently in: " + @room.name)
      expect(result.player).to eq(@player)

      # testing squeeze & downcase
      result2 = subject.run(@player, 'WHERE     am       i')
      expect(result2.message).to eq("You are currently in: " + @room.name)
    end
  end

  describe 'look' do
    it 'returns the description of the current room and player' do
      result = subject.run(@player, 'look')
      expect(result.message).to eq(@room.description)
      expect(result.player).to eq(@player)
    end
  end
end
