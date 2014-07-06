require 'spec_helper'

describe 'room' do
  before(:each) do
    @head = WWTD::Room.new(name: "Bedroom", description: "A room in which people sleep", canN: true, canE: true, canS: true, canW: true, start_new_quest: true)
    @south = WWTD::Room.new(name: 'bathroom', description: 'Just your normal bathroom', north: @head, canN: true, canE: true, canS: true, canW: true, start_new_quest: false)
    @north = WWTD::Room.new(id: 1, quest_id: 10, name: 'living room', description: 'A room with a couch, tv, and zombie', south: @head, canN: true, canE: true, canS: true, canW: true, start_new_quest: false)
  end

    it "has a name" do
      expect(@north.name).to eq('living room')
    end

    it "has a description" do
      expect(@north.description).to eq('A room with a couch, tv, and zombie')
    end

    it "has an id" do
      expect(@north.id).to_not be(nil)
    end

    it 'has a quest id' do
      expect(@north.quest_id).to eq(10)
    end

    it 'has a start_new_quest attribute that points to a boolean' do
      expect(@head.start_new_quest).to eq(true)
      expect(@north.start_new_quest).to eq(false)
    end

    it "has a north, east, south, and west direction that points to other nodes or nil" do
      expect(@north.south).to eq(@head)
      expect(@north.north).to eq(nil)
      expect(@north.east).to eq(nil)
      expect(@north.west).to eq(nil)
    end

    it "has an items inventory that is an array which stores item nodes" do
      expect(@head.items).to be_an(Array)

      jacket = WWTD::ItemNode.new(classification: 'item', name: 'jacket')
      @head.items << jacket
      expect(@head.items.size).to eq(1)
      expect(@head.items).to eq([jacket])
    end

    it 'has a characters array that stores person/zombie nodes of who is currently in the room' do
      expect(@head.characters).to be_an(Array)

      ashley = WWTD::PlayerNode.new(id: 1, name: "ashley", strength: 100)
      clay = WWTD::PlayerNode.new(id: 2, name: 'Clay', strength: 50)
      @head.characters << ashley
      @head.characters << clay
      expect(@head.characters.size).to eq(2)
      expect(@head.characters).to eq([ashley, clay])
    end

    it "has access values (canN, canE, canS, canW) that store boolean values" do
      expect(@north.canE).to eq(true)
      expect(@north.canN).to eq(true)
      expect(@north.canS).to eq(true)
      expect(@north.canW).to eq(true)
    end

    describe 'has_connection' do
      it "returns true if the room is connected to another room in the specified direction" do
        expect(@south.has_connection?('north')).to eq(true)
      end

      it 'returns false if the room does not have another room connected to it in specified direction' do
        expect(@south.has_connection?("east")).to eq(false)
      end
    end

  # describe 'addRoom' do
  #   it "adds a RoomNode to it's 'parent' node in the specified direction" do
  #     @south.addRoom(@north, 'east')
  #     expect(@south.east).to eq(@north)
  #   end

  #   it "returns nil if an improper direction is given" do
  #     expect(@south.addRoom(@north, 'northeast')).to eq(nil)
  #   end
  # end

  # describe 'removeRoom' do
  #   it "removes a RoomNode from it's parent based on specified direction" do
  #     @south.removeRoom('north')
  #     expect(@south.north).to eq(nil)
  #   end
  # end
end
