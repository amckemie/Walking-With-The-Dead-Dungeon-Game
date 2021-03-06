require 'spec_helper'

describe WWTD::UseItem do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @room = db.create_room(name: 'Bedroom', description: 'test', quest_id: 1)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @room.id)
    @jacket = db.create_item(classification: 'item',
                                name: 'jacket',
                                description: "A comfy UT jacket left over from the good ole days",
                                actions: 'put on, wear, pick up, take',
                                room_id: @room.id
                                )
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {answer_phone: true})
    db.create_room_item(player_id: @player.id, quest_id: @quest.id, room_id: @room.id, item_id: @jacket.id)
    WWTD.db.create_quest_progress(quest_id: @quest.id, player_id: @player.id, furthest_room_id: @room.id, data: @quest.data, complete: false)
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
      expect(result3.error).to eq('Sorry, that is not a known action for that.')
    end
  end

  describe 'jacket' do
    it "returns 'You are now nice and toasty with the jacket on.' if input is 'put on' or 'wear'" do
      result = WWTD::UseItem.run(@player, 'jacket', ['put', 'on','the', 'jacket'])
      expect(result.message).to eq('You are now nice and toasty with the jacket on.')

      result2 = WWTD::UseItem.run(@player, 'jacket', ['wear','the', 'jacket'])
      expect(result2.message).to eq('You are now nice and toasty with the jacket on.')
    end

    it "returns the failure message if the input is not either put on or wear" do
      result = WWTD::UseItem.run(@player, 'jacket', ['use','the', 'jacket'])
      expect(result.message).to eq('Sorry, that is not a known action for that.')
    end
  end

  describe 'TV' do
    before(:each) do
      @tv = WWTD.db.create_item(classification: 'item',
                                  name: 'tv',
                                  description: "A badass 80inch TV that a roommate once left in your lucky lucky possession.",
                                  actions: 'turn on, watch',
                                  room_id: @room.id
                                  )
    end

    it "returns 'You're going to watch the powder puff girls?? Really??' if input is 'put on' or 'wear'" do
      result = WWTD::UseItem.run(@player, 'tv', ['turn', 'on','the', 'tv'])
      expect(result.message).to eq("You're going to watch the powder puff girls?? Really??")

      result2 = WWTD::UseItem.run(@player, 'tv', ['watch','the', 'tv'])
      expect(result2.message).to eq("You're going to watch the powder puff girls?? Really??")
    end

    it "returns the failure message if the input is not either put on or wear" do
      result = WWTD::UseItem.run(@player, 'tv', ['use','the', 'tv'])
      expect(result.message).to eq('Sorry, that is not a known action for that.')
    end
  end

  describe 'socks' do
    before(:each) do
      @socks = WWTD.db.create_item(classification: 'item',
                                name: 'socks',
                                description: "A pair of grungy white socks that have held up over the years",
                                actions: 'put on, wear, pick up, take',
                                room_id: @room.id
                                )
    end
    it "returns 'You are now wearing the socks, which is kinda gross, but what can you do?' if input is 'put on' or 'wear'" do
      result = WWTD::UseItem.run(@player, 'socks', ['put', 'on','the', 'socks'])
      expect(result.message).to eq('You are now wearing the socks, which is kinda gross, but what can you do?')

      result2 = WWTD::UseItem.run(@player, 'socks', ['wear', 'socks'])
      expect(result2.message).to eq('You are now wearing the socks, which is kinda gross, but what can you do?')
    end

    it "returns the failure message if the input is not either put on or wear" do
      result = WWTD::UseItem.run(@player, 'socks', ['use','the', 'socks'])
      expect(result.message).to eq('Sorry, that is not a known action for that.')
    end
  end

  describe 'shower' do
    before(:each) do
      @shower = WWTD.db.create_item(classification: 'item',
                                name: 'shower',
                                description: "Just astand up shower in your bathroom.",
                                actions: 'get in, use, take, shower, clean',
                                room_id: @room.id
                                )
    end
    it "returns You're so fresh and so clean clean now.'' if input is 'get in', 'take', or 'shower'" do
      result = WWTD::UseItem.run(@player, 'shower', ['get', 'in','the', 'shower'])
      expect(result.message).to eq("You're so fresh and so clean clean now.")

      result2 = WWTD::UseItem.run(@player, 'shower', ['clean', 'shower'])
      expect(result2.message).to eq("Well, that's one way to start your day. But the shower is now clean.")
    end

    it "returns the failure message if the input is not either put on or wear" do
      result = WWTD::UseItem.run(@player, 'shower', ['wear','the', 'shower'])
      expect(result.message).to eq('Sorry, that is not a known action for that.')
    end
  end

  describe 'backpack (else part of statement)' do
    before(:each) do
      @backpack = db.create_item(classification: 'item',
                          name: 'backpack',
                          description: "A trusty backpack that can fit a surprising number of medical books",
                          actions: 'put on, take',
                          room_id: @room.id
                          )
      db.create_room_item(player_id: @player.id, quest_id: 1, room_id: @room.id, item_id: @backpack.id)
    end

    it 'returns success with a message of Good idea. Youll probably need this. if player enters take' do
      result = WWTD::UseItem.run(@player, 'backpack', ['take'])
      expect(result.message).to eq("Good idea. You'll probably need this.")
    end

    it "returns Good idea. Youll probably need this. if input is 'put on'" do
      result = WWTD::UseItem.run(@player, 'backpack', ['put', 'on','the', 'backpack'])
      expect(result.message).to eq("Item picked up!")
    end

    it "returns the failure message if the input is not either put on or take" do
      result = WWTD::UseItem.run(@player, 'backpack', ['wear','the', 'backpack'])
      expect(result.message).to eq('Sorry, that is not a known action for that.')
    end

    it 'is added to a persons inventory' do
      result = WWTD::UseItem.run(@player, 'backpack', ['take','the', 'backpack'])
      player_inventory = WWTD.db.get_player_inventory(@player.id)
      expect(player_inventory[0].name).to eq('backpack')
    end
  end

  describe 'take_item' do
    before(:each) do
      @backpack = db.create_item(classification: 'item',
                          name: 'backpack',
                          description: "A trusty backpack that can fit a surprising number of medical books",
                          actions: 'put on, take',
                          room_id: @room.id
                          )
    end

    it "returns a failure message of 'Sorry, you have nothing to take this item in yet.' if the backpack hasn't been picked up." do
      result = WWTD::UseItem.new.take_item('jacket', @player)
      expect(result.success?).to eq(false)
      expect(result.error).to eq("Sorry, you have nothing to take this item in yet.")
    end

    it 'returns success with a message of "Item picked up!" if player has backpack' do
      db.create_room_item(player_id: @player.id, quest_id: 1, room_id: @room.id, item_id: @backpack.id)
      db.create_inventory(@player.id, @player.room_id, @backpack.id, 1)
      result = WWTD::UseItem.new.take_item('jacket', @player)
      expect(result.success?).to eq(true)
      expect(result.message).to eq('Item picked up!')
    end

    it "adds the item to the person's inventory" do
      db.create_room_item(player_id: @player.id, quest_id: 1, room_id: @room.id, item_id: @backpack.id)
      db.create_inventory(@player.id, @player.room_id, @backpack.id, 1)
      result = WWTD::UseItem.run(@player, 'jacket', ['take', 'the', 'jacket'])
      expect(result.success?).to eq(true)
      player_inventory = WWTD.db.get_player_inventory(@player.id)
      expect(player_inventory.count).to eq(2)

    end

    # testing take / pick up through whole command
    it 'returns successfully routes to take_item method if input is take or pick up' do
      db.create_room_item(player_id: @player.id, quest_id: 1, room_id: @room.id, item_id: @backpack.id)
      db.create_inventory(@player.id, @player.room_id, @backpack.id, 1)
      result = WWTD::UseItem.run(@player, 'jacket', ['take', "the", "jacket"])
      expect(result.message).to eq("Item picked up!")

      result2 = WWTD::UseItem.run(@player, 'jacket', ['pick', "up", "the", "jacket"])
      expect(result2.message).to eq("Item picked up!")
    end
  end

  # describe 'toothbrush and toothpaste' do
  #   before(:each) do
  #     @toothpaste = WWTD.db.create_item(classification: 'item',
  #                                 name: 'Toothpaste',
  #                                 description: "So fresh and so clean, clean. ",
  #                                 actions: 'take',
  #                                 room_id: @room.id
  #                                 )
  #     @toothbrush = WWTD.db.create_item(classification: 'item',
  #                                 name: 'Toothbrush',
  #                                 description: "Don't you think you're a little old for a Spiderman toothbrush? Nah.... ",
  #                                 actions: 'brush teeth',
  #                                 room_id: @room.id
  #                                 )
  #   end

  #   it "let's you brush your teeth if you have "
  # end
end
