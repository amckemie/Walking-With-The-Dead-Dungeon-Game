require 'spec_helper'

describe WWTD::EnterLivingRoom do
  let(:db) {WWTD.db}
  before(:each) do
    db.clear_tables
    @living_room = db.create_room(name: "Player's Living Room", description: 'testing living room', quest_id: 1)
    @player = db.create_player(username: 'Ashley', password: 'eightletters', description: "Test player", room_id: @living_room.id)
    @cell = db.create_item(classification: 'item',
                                name: 'Your cell phone',
                                description: "An iPhone that's been dropped nearly one too many times",
                                actions: 'answer, pick up, call',
                                room_id: @living_room.id
                                )
    @zombie = WWTD.db.create_character(name: "First Zombie",
                        description: "HOLY SHIT! IT'S A REAL ZOMBIE AGAIN! Coming at ya fast and through that shining living room window",
                        strength: 20,
                        classification: 'zombie',
                        room_id: @living_room.id,
                        quest_id: 1
                        )
    db.create_quest_progress(quest_id: 1, player_id: @player.id, complete: false, furthest_room_id: 2, data: {first_completed_action: nil, last_completed_action: nil, last_lr_action: nil, entered_living_room: false, killed_first_zombie: false})
  end

  describe 'first entering room' do
    it 'updates a players quest_progress to state true for entered living room' do
        subject.run(@player, @living_room)
        expect(db.get_quest_progress(@player.id, 1).data['entered_living_room']).to eq(true)
    end

    it 'checks the players first action and if not use phone, player dies' do
        result = subject.run(@player, @living_room)
        expect(result.success?).to eq(true)
        expect(result.message).to eq("GAME OVER")
    end

    it 'checks the players first action and if is use phone, player has opportunity to fight zombie' do
        db.change_qp_data(@player.id, 1, first_completed_action: "answer phone")
        result = subject.run(@player, @living_room)
        expect(result.success?).to eq(true)
        expect(result.message). to eq("HOLY SHIT! IT'S A REAL ZOMBIE AGAIN! Coming at ya fast and through that shining living room window")
    end

    it 'updates the players dead attribute to true' do
        result = subject.run(@player, @living_room)
        expect(result.success?).to eq(true)
        expect(result.player.dead).to eq(true)
    end
  end

  describe 'not first time entering & zombie is dead' do
    xit 'returns the updated room description (from fight command) if player has been in room before and killed the zombie' do

    end
    xit 'returns a message with the rooms description' do
        db.change_qp_data(@player.id, 1, killed_first_zombie: true)
        result = subject.run(@player, @living_room)
        expect(result.success?).to eq(true)
        expect(result.message).to eq('A living room with a dead zombie')
    end
  end

  # if last completed action in living room is not entered and zombie is not dead, player dies because they dont fight the zombie

  describe 'not first time entering & zombie is not dead' do
  end

end
    # xit 'returns that the player died from a zombie attack if the first action is not answer phone' do
    #   living_room = db.create_room(name: "Player's Living Room", description: "locked room", west: @room1.id, quest_id: @quest.id)
    #   @updated_room1 = db.update_room(@room1.id, north: @room2.id, east: @locked_room.id, west: @room3.id)
    #   result = subject.run
    # end
