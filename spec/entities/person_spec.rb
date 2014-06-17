require 'spec_helper'

describe WWTD::PersonNode do
  let(:person) {WWTD::PersonNode.new(id: 1, name: "ashley", strength: 100)}
  let(:apple) {WWTD::ItemNode.new(id: 2, type: 'item', name: 'apple', actions: ['eat'])}
  let(:apple2) {WWTD::ItemNode.new(id: 3, type: 'item', name: 'apple', actions: ['eat'])}

  describe 'initialize' do
    it "is a PersonNode class" do
      expect(person).to be_a(WWTD::PersonNode)
    end

    it "has a name attribute" do
      expect(person.name).to eq('ashley')
    end

    it 'has an id attribute' do
      expect(person.id).to eq(1)
    end

    it 'has a strength attribute' do
      expect(person.strength).to eq(100)
    end

    it "has an inventory that is set to an empty array by default" do
      expect(person.inventory).to eq([])
    end

    it 'has an infected status set to false as default' do
      expect(person.infected).to eq(false)
    end
  end

  describe 'Inventory' do
    before(:each) do
      person.addToInventory(apple)
      person.addToInventory(apple2)
    end

    it "has a method inInventory? that checks if an item is in a personNode's inventory" do
      apple3 = WWTD::ItemNode.new(id: 10, type: 'item', name: 'apple', actions: ['eat'])
      expect(person.inInventory?(apple)).to eq(true)
      expect(person.inInventory?(apple3)).to eq(false)
    end

    it "addToInventory adds an item to a PersonNode's inventory array" do
      expect(person.inventory.size).to eq(2)
      expect(person.inventory).to eq([apple, apple2])
    end

    it "removes an item from a PersonNode's inventory array" do
      person.removeFromInventory(apple)
      expect(person.inventory.size).to eq(1)
      expect(person.inventory).to eq([apple2])
    end
  end

  describe 'eat' do
    before(:each) do
      person.addToInventory(apple)
    end

    it "only allows a person to eat an item if it's in their inventory and returns true if the action was successful" do
      expect(person.eat(apple)).to eq(true)
    end

    it "returns false if the person was unable to eat the item" do
      expect(person.eat(apple2)).to eq(false)
    end

    it "increases a person's strength by 20%" do
      person.strength = 70
      person.eat(apple)
      expect(person.strength).to eq(84)
    end

    it "doesn't increase a person's strength past 100" do
      person.eat(apple)
      expect(person.strength).to eq(100)
      expect(person.inventory.size).to eq(0)
    end

    it "removes the food from the person's inventory" do
      person.eat(apple)
      expect(person.inventory.size).to eq(0)
    end
  end

  describe 'drink' do
    before(:each) do
      @water = WWTD::ItemNode.new(id: 4, type: 'item', name: 'water', actions: ['drink', 'sip'])
      @juice = WWTD::ItemNode.new(id: 5, type: 'item', name: 'juice', actions: ['drink'])
      @coffee = WWTD::ItemNode.new(id: 6, type: 'item', name: 'coffee', actions: ['drink'])
      person.addToInventory(@juice)
      person.addToInventory(@water)
      person.strength = 50
    end

    it "increases a person's strength by 10% if it's not water" do
      expect(person.drink(@juice)).to eq(true)
      expect(person.strength).to eq(55)
    end

    it "increases a person's strength by 15% if it's water" do
      expect(person.drink(@water)).to eq(true)
      expect(person.strength).to eq(57.5)
    end

    it "only allows the person to 'drink' if it's in their inventory" do
      expect(person.drink(@coffee)).to eq(false)
      expect(person.strength).to eq(50)
    end

    it "removes the drink from the person's inventory" do
      person.drink(@water)
      expect(person.inventory).to eq([@juice])
    end
  end

  # can only do this in a room that is locked and without opponents. Command will check for this
  describe 'rest' do
    before(:each) do
      person.strength = 50
    end

    it "increases a person's strength by 15" do
      person.rest
      expect(person.strength).to eq(65)
    end

    it "does not increase a person's strength over 100" do
      person.rest
      person.rest
      person.rest
      expect(person.strength).to eq(95)
      person.rest
      expect(person.strength).to eq(100)
    end
  end

  describe 'getBit' do
    it "changes a person's infected status to true" do
      person.getBit
      expect(person.infected).to eq(true)
    end
  end
end
