require 'spec_helper'

describe WWTD::UsePhone do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: 10)
    @quest = db.create_quest(name: 'Quest Test (haha)', data: {answer_phone: nil, first_completed_action: nil})
    @room = db.create_room(name: 'Bedroom', description: 'test', quest_id: @quest.id)
    @phone = db.create_item(classification: 'item',
                            name: 'phone',
                            description: "An iPhone that's been dropped nearly one too many times",
                            actions: 'answer, pick up, call',
                            room_id: @room.id
                            )
    WWTD.db.create_quest_progress(quest_id: @quest.id, player_id: @player.id, furthest_room_id: @room.id, data: @quest.data, complete: false)
  end

  it 'returns "What call are you trying to answer? No one is calling you" if player is not in room 1' do
    result = subject.run(@player, 'answer')
    expect(result.success?).to eq(false)
    expect(result.error).to eq("What call are you trying to answer? No one is calling you.")

    result2 = subject.run(@player, 'pick up')
    expect(result.success?).to eq(false)
    expect(result.error).to eq("What call are you trying to answer? No one is calling you.")
  end

  describe 'answer in Room 1' do
    before(:each) do
      @updated_player = WWTD.db.update_player(@player.id, room_id: @room.id)
    end

    it 'returns "Your phone is no longer ringing and there are no voicemails." if answer_phone is not the first completed action' do
      WWTD.db.change_qp_data(@updated_player.id, @quest.id, first_completed_action: 'snooze')
      result = subject.run(@updated_player, 'answer')
      expect(result.success?).to eq(false)
      expect(result.error).to eq("Your phone is no longer ringing and there are no voicemails.")
    end

    it 'prints out Susies phone convo and display_message is true if answer_phone is first completed action' do
      result = subject.run(@updated_player, 'answer')
      expect(result.message).to eq("(You hear a sound as the phone is dropped and then the line cuts off.")
    end

    it 'prints out "Susie, is in trouble. Why are you trying to answer your phone again!?!" if use_phone is first completed action' do
      WWTD.db.change_qp_data(@updated_player.id, @quest.id, first_completed_action: 'use phone')
      subject.run(@updated_player, 'answer')
      result = subject.run(@updated_player, 'answer')
      expect(result.message).to eq("Susie, is in trouble. Why are you answering your phone and not trying to get to the hospital to help!?!")
    end
  end
end
