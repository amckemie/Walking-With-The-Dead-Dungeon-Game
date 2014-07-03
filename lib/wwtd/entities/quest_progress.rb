module WWTD
  class QuestProgress
    attr_reader :player_id, :quest_id, :complete, :data, :id, :room_id
    def initialize(input)
      @id = input[:id]
      @player_id = input[:player_id]
      @quest_id = input[:quest_id]
      @room_id = input[:room_id]
      @complete = input[:complete]
      @data = input[:data]
    end
  end
end
