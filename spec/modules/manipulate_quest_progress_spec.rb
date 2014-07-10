require 'spec_helper'

describe WWTD::ManipulateQuestProgress do
  let(:db) {WWTD.db}
  subject { Object.new.extend(WWTD::ManipulateQuestProgress) }

  before(:each) do
    db.clear_tables
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {answer_phone: true, first_completed_action: nil})
    @room1 = db.create_room(name: 'Bedroom', description: 'test', quest_id: @quest.id, canE: false, start_new_quest: true)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @room1.id)
    db.create_quest_progress(quest_id: @quest.id, player_id: @player.id, furthest_room_id: @room1.id, data: @quest.data, complete: false)
  end

  describe 'get data' do
    it 'returns the data hash for a specific player and quest' do
      qp_data = subject.get_quest_data(@player.id, @quest.id)
      expect(qp_data.class).to eq(Hash)
      expect(qp_data["answer_phone"]).to eq(true)
      expect(qp_data["first_completed_action"]).to eq(nil)
    end
  end

   describe 'updating quest data with latest action' do
    it 'updates "where am i" to checked room' do
      subject.update_quest_data(@player, @room1, 'checked room')
      qp_data = db.get_quest_progress(@player.id, @quest.id).data
      expect(qp_data['last_completed_action']).to_not be_nil
      expect(qp_data['last_completed_action']).to eq('checked room')
    end
  end
end
