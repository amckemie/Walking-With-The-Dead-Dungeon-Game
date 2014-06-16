require 'spec_helper'

describe 'world structure' do
  before(:each) do
    @south = RoomNode.new(name: 'bathroom', description: 'Just your normal bathroom', north: @head, locked: true)
    @north = RoomNode.new(name: 'living room', description: 'A room with a couch, tv, and zombie', south: @head, locked: false)
    @head = RoomNode.new(name: "Bedroom", description: "A room in which people sleep", north: @north, south: @south, locked: false)
    @world = WWTD::World.new(@head)
  end

  describe 'world' do
    it "points to the head/starting point" do
      expect(@world.head).to_not be(nil)
    end

    it "has a head node that points to other nodes" do
      head = @world.head
      expect(head.name).to eq('Bedroom')
      expect(head.north).to be_a(roomNode)
      expect(head.north).to eq(@north)
    end
  end

  describe 'roomNode' do
    it "has a name" do
      expect(@north.name).to eq('living room')
    end

    it "has a description" do
      expect(@north.description).to eq('A room with a couch, tv, and zombie')
    end

    it "has an id" do
      expect(@north.id).to_not be(nil)
    end

    it "has a north, east, south, and west direction that points to other nodes or nil" do
      expect(@north.south).to eq(@head)
      expect(@north.north).to eq(nil)
      expect(@north.east).to eq(nil)
      expect(@north.west).to eq(nil)
    end

    it "returns true if a room is locked" do
      expect(@world.head.south.locked).to eq(true)
    end

    it "returns false if a room is not locked" do
      expect(@world.head.north.locked).to eq(false)
    end

    it "has an items inventory that is an array which stores item nodes" do
      expect(@head.items).to be_an(Array)

      jacket = ItemNode.new(type: 'item', name: 'jacket')
      @head.items << jacket
      expect(@head.items.size).to eq(1)
      expect(@head.items).to eq([jacket])
    end

    it 'has a people array that stores person/zombie nodes of who is currently in the room' do
      expect(@head.people).to be_an(Array)

      ashley = PersonNode.new('Ashley')
      clay = PersonNode.new('Clay')
      @head.people << ashley
      @head.people << clay
      expect(@head.people.size).to eq(2)
      expect(@head.people).to eq([ashley, clay])
    end
  end
end
