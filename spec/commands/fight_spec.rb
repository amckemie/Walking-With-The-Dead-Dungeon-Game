require 'spec_helper'

describe 'fight' do
  let(:db) {WWTD.db}

  before(:each) do
    db.clear_tables
    @zombie = db.create_character(name: 'bloody clown zombie', classification: 'zombie', description: 'a scary zombie', quest_id: 1, room_id: 2, strength: 20)
    @player_1 = db.create_player(username: 'zombiekilla', password: 'eightletters', description: 'a zombie killing machine', room_id: 1)
    @quest_character1 = db.create_quest_character(player_id: @player_1.id, character_id: @zombie.id, quest_id: 1, room_id: 2)
    @fight = WWTD::Fight.new
  end

  describe 'winning fight' do
    before(:each) do
      @result = @fight.run(@player_1, @zombie, false)
    end

    it "returns a success message that the person won the fight if they have more strength than opponent" do
      expect(@result[:success?]).to eq(true)
      expect(@result[:message]).to eq("Whew! You killed the bloody clown zombie!")
    end

    it "deletes the opponent from the players game if they are killed when the person wins" do
      expect(@result[:deleted?]).to eq(true)
    end

    it 'decreases the players strength by the opponents strength and saves it in the db' do
      test_player = db.get_player_by_username('zombiekilla')
      expect(test_player.strength).to eq(80)
    end
  end

  describe 'losing fight' do
    before(:each) do
      @player2 = db.create_player(username: 'test', password: 'testingtesting', description: 'a zombie killing machine', strength: 10, room_id: 1)
      @zombie2 = db.create_character(name: 'bloody clown zombie', classification: 'zombie', description: 'a scary zombie', quest_id: 1, room_id: 2, strength: 20)
      @result2 = @fight.run(@player2, @zombie2, false)
    end

    it "returns that the person lost the fight if they have less than or equal strength than/of opponent" do
      expect(@result2[:success?]).to eq(false)
      expect(@result2[:message]).to eq('Oh nooossssssss! The zombie bit you! So sorry, but you are now infected.')
    end

    it "kills the person if they lose the fight" do
      expect(@result2[:player].dead).to eq(true)
    end
  end

  # not great test...ask how to do better
  describe 'shoot' do
    it 'randomly chooses if the player wins if they "shoot" the opponent' do
      shoot_result = @fight.run(@player_1, @zombie, true)
      expect(shoot_result[:success?]).to_not be_nil
      expect(shoot_result[:message]).to_not be_nil
      p shoot_result
    end
  end
end
