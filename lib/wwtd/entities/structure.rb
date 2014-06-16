module WWTD
  # world is a data structure similar to a tree in which a set of nodes are interlinked based on their directions (north, east, south, west).
  # It's head node is the bedroom in which the player initially finds him/her self.
  class World
    def initialize(head)
    end
  end

  # rooms are the individual nodes that make up a world. They do not have parents or children, but rather other nodes connected to them
  # via direction (n, e, s, w)
  class RoomNode
    def initialize()
    end
  end
end
