require 'spec_helper'

describe WWTD::Fight do
  let(:db) {WWTD.db}

  before(:each) do
    db.clear_tables
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {answer_phone: nil, first_completed_action: nil})
    @room = db.create_room(name: 'Bedroom', description: 'test', quest_id: @quest.id)
    @zombie = db.create_character(name: 'bloody clown zombie', classification: 'zombie', description: 'a scary zombie', quest_id: @quest.id, room_id: @room.id, strength: 20)
    @player_1 = db.create_player(username: 'zombiekilla', password: 'eightletters', description: 'a zombie killing machine', room_id: @room.id)
    @quest_character1 = db.create_quest_character(player_id: @player_1.id, character_id: @zombie.id, quest_id: @quest.id, room_id: @room.id)
  end

  describe 'checking if should fight' do
    it 'checks a players room and if there is a zombie in that room for the player. Returns "no zombie to fight here" if not' do
      room2 = db.create_room(name: 'Kitchen', description: 'test', quest_id: @quest.id)
      updated_player = db.update_player(@player_1.id, room_id: room2.id)
      result = subject.run(updated_player)
      expect(result.success?).to eq(false)
      expect(result.error).to eq("Save your energy. There's no zombie to fight here.")
    end

    it 'returns a success message with the player winning or losing if there is a zombie in the room' do
      result = subject.run(@player_1)
      expect(result.success?).to eq(true)
      expect(result.message).to_not be_nil
    end
  end

  describe 'winning fight' do
    before(:each) do
      @result = subject.run(@player_1)
    end

    it "returns a success message that the person won the fight if they have more strength than opponent" do
      expect(@result.success?).to eq(true)
      expect(@result.message).to eq("Whew! You killed the bloody clown zombie!")
    end

    it "deletes the opponent from the players game if they are killed when the person wins" do
      expect(@result.deleted?).to eq(true)
    end

    it 'decreases the players strength by the opponents strength and saves it in the db' do
      test_player = db.get_player_by_username('zombiekilla')
      expect(test_player.strength).to eq(80)
    end
  end

  describe 'losing fight' do
    before(:each) do
      @player2 = db.create_player(username: 'test', password: 'testingtesting', description: 'a zombie killing machine', strength: 10, room_id: @room.id)
      @zombie2 = db.create_character(name: 'bloody clown zombie', classification: 'zombie', description: 'a scary zombie', quest_id: @quest.id, room_id: @room.id, strength: 20)
      db.create_quest_character(player_id: @player2.id, character_id: @zombie2.id, quest_id: @quest.id, room_id: @room.id)
      @result2 = subject.run(@player2)
    end

    it "returns that the person lost the fight if they have less than or equal strength than/of opponent" do
      expect(@result2.message).to eq('Oh nooossssssss! The zombie bit you! So sorry, but you are now infected.')
    end

    it "kills the person if they lose the fight" do
      expect(@result2.player.dead).to eq(true)
    end
  end

  # not great test...ask how to do better
  describe 'shoot' do
    it 'randomly chooses if the player wins if they "shoot" the opponent' do
      shoot_result = subject.run(@player_1)
      expect(shoot_result.success?).to_not be_nil
      expect(shoot_result.message).to_not be_nil
      p shoot_result
    end
  end

  after(:each) do
    db.clear_tables
  end
end
