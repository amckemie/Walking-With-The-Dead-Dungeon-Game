require 'spec_helper'

describe 'zombie' do
  before(:each) do
    @zombie = WWTD::ZombieNode.new(id: 1, description: 'a gruesome zombie if there ever was one', strength: 70, canGrab: true, canWalk: true)
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

    it "has a canGrab attribute" do
      expect(@zombie.canGrab).to eq(true)

      @zombie.canGrab = false
      expect(@zombie.canGrab).to eq(false)
    end

    it "has a canWalk attribute" do
      expect(@zombie.canWalk).to eq(true)

      @zombie.canWalk = false
      expect(@zombie.canWalk).to eq(false)
    end
  end

  describe 'bite' do
    before do
      @person = WWTD::PersonNode.new(id: 1, name: "ashley", strength: 100, infected: false)
    end

    it "changes a Person's infected status to true" do
      @zombie.bite(@person)
      expect(@person.infected).to eq(true)
    end
  end
end
