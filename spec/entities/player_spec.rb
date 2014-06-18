require 'spec_helper.rb'

describe WWTD::PlayerNode do
  let(:player) {WWTD::PlayerNode.new(id: 1, username: 'ashley', password: 'abc123', strength: 100, description: 'badass zombie killer')}
  let(:apple) {WWTD::ItemNode.new(id: 2, type: 'item', name: 'apple', actions: ['eat'])}
  let(:apple2) {WWTD::ItemNode.new(id: 3, type: 'item', name: 'apple', actions: ['eat'])}

  describe 'initialize' do
    it "is a playerNode class" do
      expect(player).to be_a(WWTD::PlayerNode)
    end

    it "has a username attribute" do
      expect(player.username).to eq('ashley')
    end

    it "has a password attribute" do
      expect(player.password).to eq('abc123')
    end

    it "has a description attribute" do
      expect(player.description).to eq('badass zombie killer')
    end

    it 'has an id attribute' do
      expect(player.id).to eq(1)
    end

    it 'has a strength attribute' do
      expect(player.strength).to eq(100)
    end

    it "has an inventory that is set to an empty array by default" do
      expect(player.inventory).to eq([])
    end

    it 'has an dead status set to false as default' do
      expect(player.dead).to eq(false)
    end
  end

  describe 'Inventory' do
    before(:each) do
      player.addToInventory(apple)
      player.addToInventory(apple2)
    end

    it "has a method inInventory? that checks if an item is in a playerNode's inventory" do
      apple3 = WWTD::ItemNode.new(id: 10, type: 'item', name: 'apple', actions: ['eat'])
      expect(player.inInventory?(apple)).to eq(true)
      expect(player.inInventory?(apple3)).to eq(false)
    end

    it "addToInventory adds an item to a playerNode's inventory array" do
      expect(player.inventory.size).to eq(2)
      expect(player.inventory).to eq([apple, apple2])
    end

    it "removes an item from a playerNode's inventory array" do
      player.removeFromInventory(apple)
      expect(player.inventory.size).to eq(1)
      expect(player.inventory).to eq([apple2])
    end
  end

  describe 'eat' do
    before(:each) do
      player.addToInventory(apple)
    end

    it "only allows a player to eat an item if it's in their inventory and returns true if the action was successful" do
      expect(player.eat(apple)).to eq(true)
    end

    it "returns false if the player was unable to eat the item" do
      expect(player.eat(apple2)).to eq(false)
    end

    it "increases a player's strength by 20%" do
      player.strength = 70
      player.eat(apple)
      expect(player.strength).to eq(84)
    end

    it "doesn't increase a player's strength past 100" do
      player.eat(apple)
      expect(player.strength).to eq(100)
      expect(player.inventory.size).to eq(0)
    end

    it "removes the food from the player's inventory" do
      player.eat(apple)
      expect(player.inventory.size).to eq(0)
    end
  end

  describe 'drink' do
    before(:each) do
      @water = WWTD::ItemNode.new(id: 4, type: 'item', name: 'water', actions: ['drink', 'sip'])
      @juice = WWTD::ItemNode.new(id: 5, type: 'item', name: 'juice', actions: ['drink'])
      @coffee = WWTD::ItemNode.new(id: 6, type: 'item', name: 'coffee', actions: ['drink'])
      player.addToInventory(@juice)
      player.addToInventory(@water)
      player.strength = 50
    end

    it "increases a player's strength by 10% if it's not water" do
      expect(player.drink(@juice)).to eq(true)
      expect(player.strength).to eq(55)
    end

    it "increases a player's strength by 15% if it's water" do
      expect(player.drink(@water)).to eq(true)
      expect(player.strength).to eq(57.5)
    end

    it "only allows the player to 'drink' if it's in their inventory" do
      expect(player.drink(@coffee)).to eq(false)
      expect(player.strength).to eq(50)
    end

    it "removes the drink from the player's inventory" do
      player.drink(@water)
      expect(player.inventory).to eq([@juice])
    end
  end

  # can only do this in a room that is locked and without opponents. Command will check for this
  describe 'rest' do
    before(:each) do
      player.strength = 50
    end

    it "increases a player's strength by 15" do
      player.rest
      expect(player.strength).to eq(65)
    end

    it "does not increase a player's strength over 100" do
      player.rest
      player.rest
      player.rest
      expect(player.strength).to eq(95)
      player.rest
      expect(player.strength).to eq(100)
    end
  end

  describe 'getBit' do
    it "changes a player's dead status to true" do
      player.getBit
      expect(player.dead).to eq(true)
    end
  end
end
