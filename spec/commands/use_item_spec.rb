require 'spec_helper'

describe WWTD::UseItem do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @room = db.create_room(name: 'Bedroom', description: 'test', quest_id: 1)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @room.id)
    @jacket = WWTD.db.create_item(classification: 'item',
                                name: 'jacket',
                                description: "A comfy UT jacket left over from the good ole days",
                                actions: 'put on, wear, pick up, take',
                                room_id: @room.id
                                )
  end

  describe 'preparing input' do
    it 'parses the array down to the 1st 4 inputted words' do
      input = WWTD::UseItem.new.prepare_input('jacket', ['put','on', 'two', 'shirt', 'with','my', 'hands'])
      expect(input).to eq(['put', 'on', 'two', 'shirt'])

      input2 = WWTD::UseItem.new.prepare_input('jacket', ['wear', 'two', 'shirt'])
      expect(input2).to eq(['wear', 'two', 'shirt'])
    end

    it 'deletes the item' do
      input = WWTD::UseItem.new.prepare_input('jacket', ['put','on', 'two', 'jacket', 'with','my', 'hands'])
      expect(input).to eq(['put', 'on','two'])

      input2 = WWTD::UseItem.new.prepare_input('jacket', ['put','on', 'jacket','too', 'with','my', 'hands'])
      expect(input2).to eq(['put', 'on','too'])
    end

    it 'deletes common articles/conjunctions' do
      input = WWTD::UseItem.new.prepare_input('jacket', ['put','on', 'the', 'jacket', 'with','my', 'hands'])
      expect(input).to eq(['put', 'on'])
    end
  end

  describe 'checking items actions' do
    before(:each) do
      @result = WWTD::UseItem.new.check_item_actions('jacket', ['wear'])
      @result2 = WWTD::UseItem.new.check_item_actions('jacket', ['put', 'on',])
    end

    it 'returns success true if the inputted action is a recognized one for the item' do
      expect(@result.success?).to eq(true)
      expect(@result2.success?).to eq(true)
    end

    it 'returns the recognized action if success is true' do
      expect(@result.action).to eq('wear')
      expect(@result2.action).to eq('put on')
    end

    it 'returns success false if the inputted action is not recognized for the item' do
      result3 = WWTD::UseItem.new.check_item_actions('jacket', ['put', 'the', 'on'])
      expect(result3.success?).to eq(false)
    end
  end

  # describe 'using phone' do
  # end


end
