require 'spec_helper'

describe WWTD::NewQuest do
  let(:db) {WWTD.db}
  before(:each) do
    @quest = db.create_quest(name: 'Quest Test (haha)')
    @room1 = db.create_room(name: 'Bedroom', description: 'test', quest_id: @quest.id, start_new_quest: true)
    @room2 = db.create_room(name: 'Kitchen', description: 'room with food', south: @room1.id, quest_id: @quest.id)
    db.update_room(@room1.id, north: @room2.id)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player")
  end

  describe 'Check room' do
    it "returns new_quest? true if the room is supposed to start a new quest" do
      result = subject.run(@room1, @player.id)
      expect(result.start_new_quest?).to eq(true)
    end

    it "returns new_quest? falase if the room is not supposed to start a new quest" do
      result2 = subject.run(@room2, @player.id)
      expect(result2.start_new_quest?).to eq(false)
    end
  end

  describe 'creating new quests' do
    it 'creates a new quest for the player if the room has returns true for new_quest?' do
      result = subject.run(@room1, @player.id)
      expect(result.quest_progress.class).to eq(WWTD::QuestProgress)
      expect(result.quest_progress.complete).to eq(false)
      expect(result.quest_progress.player_id).to eq(@player.id)
      expect(result.quest_progress.quest_id).to eq(@quest.id)
    end

    it 'does not create a new quest if the room returns false for new_quest?' do
      result = subject.run(@room2, @player.id)
      expect(result.quest_progress).to eq(false)
    end
  end
end
