require 'spec_helper'

describe WWTD::characterNode do
  let(:character) {WWTD::characterNode.new(id: 1, name: "ashley", strength: 100, description: 'badass zombie killer')}
  let(:apple) {WWTD::ItemNode.new(id: 2, type: 'item', name: 'apple', actions: ['eat'])}
  let(:apple2) {WWTD::ItemNode.new(id: 3, type: 'item', name: 'apple', actions: ['eat'])}

  describe 'initialize' do
    it "is a characterNode class" do
      expect(character).to be_a(WWTD::characterNode)
    end

    it "has a name attribute" do
      expect(character.name).to eq('ashley')
    end

    it "has a description attribute" do
      expect(character.description).to eq('badass zombie killer')
    end

    it 'has an id attribute' do
      expect(character.id).to eq(1)
    end

    it 'has a strength attribute' do
      expect(character.strength).to eq(100)
    end

    it "has an inventory that is set to an empty array by default" do
      expect(character.inventory).to eq([])
    end

    it 'has an infected status set to false as default' do
      expect(character.infected).to eq(false)
    end

    it 'has an dead status set to false as default' do
      expect(character.dead).to eq(false)
    end
  end

  describe 'Inventory' do
    before(:each) do
      character.addToInventory(apple)
      character.addToInventory(apple2)
    end

    it "has a method inInventory? that checks if an item is in a characterNode's inventory" do
      apple3 = WWTD::ItemNode.new(id: 10, type: 'item', name: 'apple', actions: ['eat'])
      expect(character.inInventory?(apple)).to eq(true)
      expect(character.inInventory?(apple3)).to eq(false)
    end

    it "addToInventory adds an item to a characterNode's inventory array" do
      expect(character.inventory.size).to eq(2)
      expect(character.inventory).to eq([apple, apple2])
    end

    it "removes an item from a characterNode's inventory array" do
      character.removeFromInventory(apple)
      expect(character.inventory.size).to eq(1)
      expect(character.inventory).to eq([apple2])
    end
  end

  describe 'eat' do
    before(:each) do
      character.addToInventory(apple)
    end

    it "only allows a character to eat an item if it's in their inventory and returns true if the action was successful" do
      expect(character.eat(apple)).to eq(true)
    end

    it "returns false if the character was unable to eat the item" do
      expect(character.eat(apple2)).to eq(false)
    end

    it "increases a character's strength by 20%" do
      character.strength = 70
      character.eat(apple)
      expect(character.strength).to eq(84)
    end

    it "doesn't increase a character's strength past 100" do
      character.eat(apple)
      expect(character.strength).to eq(100)
      expect(character.inventory.size).to eq(0)
    end

    it "removes the food from the character's inventory" do
      character.eat(apple)
      expect(character.inventory.size).to eq(0)
    end
  end

  describe 'drink' do
    before(:each) do
      @water = WWTD::ItemNode.new(id: 4, type: 'item', name: 'water', actions: ['drink', 'sip'])
      @juice = WWTD::ItemNode.new(id: 5, type: 'item', name: 'juice', actions: ['drink'])
      @coffee = WWTD::ItemNode.new(id: 6, type: 'item', name: 'coffee', actions: ['drink'])
      character.addToInventory(@juice)
      character.addToInventory(@water)
      character.strength = 50
    end

    it "increases a character's strength by 10% if it's not water" do
      expect(character.drink(@juice)).to eq(true)
      expect(character.strength).to eq(55)
    end

    it "increases a character's strength by 15% if it's water" do
      expect(character.drink(@water)).to eq(true)
      expect(character.strength).to eq(57.5)
    end

    it "only allows the character to 'drink' if it's in their inventory" do
      expect(character.drink(@coffee)).to eq(false)
      expect(character.strength).to eq(50)
    end

    it "removes the drink from the character's inventory" do
      character.drink(@water)
      expect(character.inventory).to eq([@juice])
    end
  end

  # can only do this in a room that is locked and without opponents. Command will check for this
  describe 'rest' do
    before(:each) do
      character.strength = 50
    end

    it "increases a character's strength by 15" do
      character.rest
      expect(character.strength).to eq(65)
    end

    it "does not increase a character's strength over 100" do
      character.rest
      character.rest
      character.rest
      expect(character.strength).to eq(95)
      character.rest
      expect(character.strength).to eq(100)
    end
  end

  describe 'getBit' do
    it "changes a character's infected status to true" do
      character.getBit
      expect(character.infected).to eq(true)
    end
  end
end
