module WWTD
  class QuestProgress
    attr_reader :player_id, :quest_id, :complete, :data, :id, :furthest_room_id
    def initialize(input)
      @id = input[:id]
      @player_id = input[:player_id]
      @quest_id = input[:quest_id]
      @furthest_room_id = input[:furthest_room_id]
      @complete = input[:complete]
      @data = input[:data]
    end
  end
end
