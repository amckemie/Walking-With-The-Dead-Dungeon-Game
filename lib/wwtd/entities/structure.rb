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
    attr_accessor :name, :description, :north, :south, :east, :west, :canAccess, :locked, :people, :items
    attr_accessor :id, :canN, :canE, :canS, :canW
    def initialize(input)
      @id = input[:id]
      @name = input[:name]
      @description = input[:description]
      @north = input[:north]
      @south = input[:south]
      @west = input[:west]
      @east = input[:east]
      @canN = true
      @canE = true
      @canS = true
      @canW = true
      @people = input[:people] ||= []
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
