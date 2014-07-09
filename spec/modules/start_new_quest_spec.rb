require 'spec_helper'

describe WWTD::StartNewQuest do
  let(:db) {WWTD.db}
  subject { Object.new.extend(WWTD::StartNewQuest) }

  before(:each) do
    db.clear_tables
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {answer_phone: true})
    @room1 = db.create_room(name: 'Bedroom', description: 'test', quest_id: @quest.id, canE: false, start_new_quest: true)
    @room2 = db.create_room(name: 'Kitchen', description: 'room with food', south: @room1.id, quest_id: @quest.id, start_new_quest: false)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @room1.id)
  end

  describe 'Check for new quest' do
    describe 'it is a new quest' do
      before(:each) do
        @result = subject.start_new_quest?(@room1, @player)
      end
      it "returns new_quest? true if the room is supposed to start a new quest" do
        expect(@result).to eq(true)
      end

      it 'creates a new quest progress record for the player' do
        quests = WWTD.db.get_player_quests(@player.id)
        expect(quests.count).to eq(1)
      end
    end

    describe 'not a new quest' do
      before(:each) do
        @result = subject.start_new_quest?(@room2, @player)
      end
      it "returns new_quest? false if the room is not supposed to start a new quest" do
        expect(@result).to eq(false)
      end

      it 'does not create a new quest progress record for the player' do
        expect(WWTD.db.get_player_quests(@player.id)).to eq(nil)
      end
    end
  end

  describe 'creating room items' do
    before(:each) do
      @cell = db.create_item(classification: 'item',
                                name: 'Your cell phone',
                                description: "An iPhone that's been dropped nearly one too many times",
                                actions: 'answer, pick up, call',
                                room_id: @room1.id
                                )
      db.create_quest_item(item_id: @cell.id, room_id: @room1.id, quest_id: @quest.id)
      @sword = db.create_item(classification: 'weapon',
                                name: "Sword",
                                description: "Sharp, pointy, and made for killin",
                                actions: 'cut, stab',
                                room_id: 10
                                )
      db.create_quest_item(item_id: @sword.id, room_id: 10, quest_id: 2)
    end

    it 'creates a record for every item in the rooms included in the new quest for the player' do
      result = subject.start_new_quest?(@room1, @player)
      expect(result).to eq(true)
      room_items = WWTD.db.get_quest_items_left(@player.id, @quest.id)
      expect(room_items.count).to eq(1)
      expect(room_items.first.name).to eq('Your cell phone')
    end
  end

  describe 'creating quest characters' do
    before(:each) do
      @char = db.create_character(name: 'bloody clown zombie', classification: 'zombie', description: 'a scary zombie', quest_id: @quest.id, room_id: @room1.id, strength: 20)
      @char2 = db.create_character(name: 'susie', classification: 'character', description: 'best friend', quest_id: @quest.id, room_id: @room2.id)
    end

    it 'creates a record for every character in the quest for the player' do
      result = subject.start_new_quest?(@room1, @player)
      expect(result).to eq(true)

      quest_characters = WWTD.db.get_players_quest_characters(@player.id, @quest.id)
      expect(quest_characters.count).to eq(2)
    end
  end

  describe 'creating player rooms' do
    it 'creates a record for a player for each room in the new quest' do
      subject.start_new_quest?(@room1, @player)
      expect(db.get_player_room(@player.id, @room1.id)).to_not be_nil
      expect(db.get_player_room(@player.id, @room2.id)).to_not be_nil
    end
  end
end
