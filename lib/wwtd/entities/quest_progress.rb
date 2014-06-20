module WWTD
  class QuestProgress
    attr_reader :player_id, :quest_id, :complete, :data

    def initialize(input)
      @player_id = input[:player_id]
      @quest_id = input[:quest_id]
      @complete = input[:complete]
      @data = input[:data]
    end
  end
end
