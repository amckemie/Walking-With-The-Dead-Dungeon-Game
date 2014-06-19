require 'spec_helper'

describe 'zombie' do
  before(:each) do
    @zombie = WWTD::ZombieNode.new(id: 1, name: 'scary zombie', description: 'a gruesome zombie if there ever was one', strength: 70, killed: false, room_id: 2, quest_id: 1, dead: false)
  end

  describe 'initialize' do
    it "has an id" do
      expect(@zombie.id).to eq(1)
    end

    it "has a description" do
      expect(@zombie.description).to eq('a gruesome zombie if there ever was one')
    end

    it 'has a strength attribute' do
      expect(@zombie.strength).to eq(70)
    end

    it "has a name attribute" do
      expect(@zombie.name).to eq('scary zombie')
    end

    it 'has a roomId' do
      expect(@zombie.room_id).to eq(2)
    end

    it 'has a quest_id' do
      expect(@zombie.quest_id).to eq(1)
    end
    it 'has a dead attribute' do
    expect(@zombie.dead).to eq(false)
  end
  end

  describe 'bite' do
    before do
      @person = WWTD::PlayerNode.new(id: 1, username: 'ashley', password: 'abc123', strength: 100, description: 'badass zombie killer')
    end

    it "changes a Person's dead status to true" do
      @zombie.bite(@person)
      expect(@person.dead).to eq(true)
    end
  end
end
