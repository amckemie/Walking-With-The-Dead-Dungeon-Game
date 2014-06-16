require 'spec_helper'

describe WWTD::PersonNode do
  let(:person) {WWTD::PersonNode.new(id: 1, name: "ashley", strength: 100)}

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
  end

  describe 'addToInventory' do
  end

  describe 'removeFromInventory' do
  end

  describe 'eat' do
    xit "increases a person's strength by the amount that specific food gives" do
      apple = WWTD::ItemNode('apple')
    end

    xit "doesn't increase a person's strength past 100" do
    end

    xit "removes the food from the person's inventory" do
    end
  end

  describe 'drink' do
    xit "increase a person's strength by the drink's strength percentage" do
    end

    xit "removes the drink from the person's inventory" do
    end
  end

  describe 'rest' do
  end
end
