module WWTD
  # rooms are the individual nodes that make up a world. They do not have parents or children, but rather other nodes connected to them
  # via direction (n, e, s, w)
  class Room
    attr_reader :name, :description, :characters, :items, :id, :canN, :canE, :canS, :canW, :quest_id, :start_new_quest
    attr_accessor :north, :south, :east, :west
    def initialize(input)
      @id = input[:id]
      @quest_id = input[:quest_id]
      @name = input[:name]
      @description = input[:description]
      @start_new_quest = input[:start_new_quest]
      @north = input[:north]
      @south = input[:south]
      @west = input[:west]
      @east = input[:east]
      @canN = input[:canN]
      @canE = input[:canE]
      @canS = input[:canS]
      @canW = input[:canW]
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
