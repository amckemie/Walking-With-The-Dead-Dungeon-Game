require 'spec_helper'

describe 'zombie' do
  before(:each) do
    @zombie = WWTD::ZombieNode.new(id: 1, description: 'a gruesome zombie if there ever was one', strength: 70, killed: false, roomId: 2, questId: 1)
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

    it "has a default killed attribute of false" do
      expect(@zombie.killed).to eq(false)
    end

    it 'has a roomId' do
      expect(@zombie.roomId).to eq(2)
    end

    it 'has a questId' do
      expect(@zombie.questId).to eq(1)
    end
  end

  describe 'bite' do
    before do
      @person = WWTD::CharacterNode.new(id: 1, name: "ashley", strength: 100, infected: false)
    end

    it "changes a Person's infected status to true" do
      @zombie.bite(@person)
      expect(@person.infected).to eq(true)
    end
  end
end
