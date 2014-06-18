module WWTD
  # world is a data structure similar to a tree in which a set of nodes are interlinked based on their directions (north, east, south, west).
  # It's head node is the bedroom in which the player initially finds him/her self.
  class World
    attr_reader :head
    def initialize(head)
      @head = head
    end

  end

  # rooms are the individual nodes that make up a world. They do not have parents or children, but rather other nodes connected to them
  # via direction (n, e, s, w)
  class RoomNode
    attr_reader :name, :description, :characters, :items, :id, :canN, :canE, :canS, :canW, :questId
    attr_accessor :north, :south, :east, :west
    def initialize(input)
      @id = input[:id]
      @questId = input[:questId]
      @name = input[:name]
      @description = input[:description]
      @north = input[:north]
      @south = input[:south]
      @west = input[:west]
      @east = input[:east]
      @canN = input[:canN] ||= true
      @canE = input[:canE] ||= true
      @canS = input[:canS] ||= true
      @canW = input[:canW] ||= true
      @characters = input[:characters] ||= []
      @items = input[:items] ||= []
    end

    def addRoom(node, direction)
      case direction
      when 'north'
        @north = node
      when 'east'
        @east = node
      when 'south'
        @south = node
      when 'west'
        @west = node
      else
        return nil
      end
    end

    def removeRoom(direction)
      case direction
      when 'north'
        @north = nil
      when 'east'
        @east = nil
      when 'south'
        @south = nil
      when 'west'
        @west = nil
      end
    end
  end
end
