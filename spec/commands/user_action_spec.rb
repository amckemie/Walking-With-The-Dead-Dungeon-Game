require 'spec_helper'

describe WWTD::UserAction do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @room = db.create_room(name: 'Bedroom', description: 'test', quest_id: 1)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @room.id)
    db.create_quest_progress(quest_id: 1, player_id: @player.id, complete: false, furthest_room_id: 2, data: {first_completed_action: nil, last_completed_action: nil, entered_living_room: false, killed_first_zombie: false})
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
      qp_data = db.get_quest_progress(@player.id, 1).data
      expect(qp_data['last_completed_action']).to eq('checked description')
    end
  end
end
