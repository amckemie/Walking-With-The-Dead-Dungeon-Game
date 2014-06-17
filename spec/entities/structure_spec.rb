require 'spec_helper'

describe 'world structure' do
  before(:each) do
    @head = WWTD::RoomNode.new(name: "Bedroom", description: "A room in which people sleep")
    @south = WWTD::RoomNode.new(name: 'bathroom', description: 'Just your normal bathroom', north: @head, locked: true)
    @north = WWTD::RoomNode.new(id: 1, name: 'living room', description: 'A room with a couch, tv, and zombie', south: @head, locked: false, canAccess: {north: true, east: false, south: true, west: false})
    @world = WWTD::World.new(@head)
  end

  describe 'world' do
    describe 'initialize' do
      it "points to the head/starting point" do
        expect(@world.head).to_not be(nil)
      end

      it "has a head node that points to other nodes" do
        head = @world.head
        head.north = @north
        expect(head.name).to eq('Bedroom')
        expect(head.north).to be_a(WWTD::RoomNode)
        expect(head.north).to eq(@north)
      end
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
      expect(@south.locked).to eq(true)
    end

    it "returns false if a room is not locked" do
      expect(@north.locked).to eq(false)
    end

    it "gives locked a default value  of false" do
      expect(@head.locked).to eq(false)
    end

    it "has an items inventory that is an array which stores item nodes" do
      expect(@head.items).to be_an(Array)

      jacket = WWTD::ItemNode.new(type: 'item', name: 'jacket')
      @head.items << jacket
      expect(@head.items.size).to eq(1)
      expect(@head.items).to eq([jacket])
    end

    it 'has a people array that stores person/zombie nodes of who is currently in the room' do
      expect(@head.people).to be_an(Array)

      ashley = WWTD::PersonNode.new(id: 1, name: "ashley", strength: 100)
      clay = WWTD::PersonNode.new(id: 2, name: 'Clay', strength: 50)
      @head.people << ashley
      @head.people << clay
      expect(@head.people.size).to eq(2)
      expect(@head.people).to eq([ashley, clay])
    end

    it "has a can_access hash that stores 4 boolean values for the 4 cardinal directions: true if you can go in a direction, false if not" do
      expect(@north.canAccess[:north]).to eq(true)
      expect(@north.canAccess[:west]).to eq(false)
    end
  end

  describe 'addRoom' do
    it "adds a RoomNode to it's 'parent' node in the specified direction" do
      @south.addRoom(@north, 'east')
      expect(@south.east).to eq(@north)
    end

    it "returns nil if an improper direction is given" do
      expect(@south.addRoom(@north, 'northeast')).to eq(nil)
    end
  end

  describe 'removeRoom' do
    it "removes a RoomNode from it's parent based on specified direction" do
      @south.removeRoom(north)
      expect(@south.north).to eq(nil)
    end
  end
end
