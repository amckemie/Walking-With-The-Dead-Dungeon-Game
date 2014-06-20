require 'spec_helper'

describe WWTD::ActiveRecordDatabase do
  before { db.clear_tables }
  let(:db) {subject}
  let(:player_1) {db.create_player(username: 'zombiekilla', password: 'eightletters', description: 'a zombie killing machine', room_id: 1)}
  let(:player_2) {db.create_player(username: 'zombieloser', password: 'areabitch', description: 'a non-zombie killing machine', room_id: 1)}
  let(:item_1) {db.create_item(name: 'apple', description: "yummy red apple", classification: 'item', actions: 'take, eat', room_id: 1)}
  let(:weapon_1) {db.create_item(name: 'sword', classification: 'weapon', description: "a sharp pointy thing", actions: 'take, stab, cut', parent_item: item_1.id, room_id: 10)}
  let(:kitchen) {db.create_room(name: 'kitchen', description: 'a bright sunny room with food')}
  let(:bedroom) {db.create_room(name: 'bedroom', description: 'a place to sleep', north: kitchen.id, canW: false)}
  let(:quest_1) {db.create_quest(name: 'the holy grail')}
  let(:zombie_1) {db.create_character(name: 'bloody clown zombie', classification: 'zombie', description: 'a scary zombie', quest_id: quest_1.id, room_id: bedroom.id, strength: 20)}
  let(:character_1) {db.create_character(name: 'Susie', description: "best friend", classification: 'person', quest_id: quest_1.id, room_id: kitchen.id)}
  let(:quest_2) {db.create_quest(name: 'beat the zombie!')}
  let(:room_item1) {db.create_room_item(player_id: player_1.id, quest_id: quest_1.id, room_id: kitchen.id, item_id: item_1.id)}
  let(:room_item2) {db.create_room_item(player_id: player_1.id, quest_id: quest_1.id, room_id: kitchen.id, item_id: weapon_1.id, parent_item_id: item_1.id)}

  # quests
  describe 'Quest' do
    describe 'create_quest' do
      it 'returns a WWTD::Quest' do
        expect(quest_1.class).to eq(WWTD::Quest)
      end

      it 'it has a name and id' do
        expect(quest_1.id).to_not be_nil
        expect(quest_1.name).to eq('the holy grail')
      end
    end

    it 'can be retrieved by id' do
      retrieved_quest = db.get_quest(quest_1.id)
      expect(retrieved_quest.class).to eq(WWTD::Quest)
      expect(retrieved_quest.name).to eq('the holy grail')
    end

    it 'can be updated' do
      test = db.update_quest(quest_1.id, name: 'the unholiest of grails')
      updated = db.get_quest(quest_1.id)
      expect(updated.id).to eq(quest_1.id)
      expect(updated.name).to eq(test.name)
    end

    it 'can be deleted' do
      expect(db.delete_quest(quest_1.id)).to eq(true)
    end
  end

  # rooms
  describe 'QuestItems' do
    before(:each) do
      @quest_item_test = db.create_quest_item(quest_id: quest_1.id, item_id: item_1.id, room_id: kitchen.id)
      @quest_item_test2 = db.create_quest_item(quest_id: quest_2.id, item_id: item_1.id, room_id: bedroom.id)
      @quest_item_test3 = db.create_quest_item(quest_id: quest_1.id, item_id: item_1.id, room_id: bedroom.id)
    end

    it 'creates a record of each item and quest association, in addition to the room_id' do
      expect(@quest_item_test.id).to_not be_nil
      expect(@quest_item_test.quest_id).to eq(quest_1.id)
      expect(@quest_item_test.item_id).to eq(item_1.id)
      expect(@quest_item_test2.room_id).to eq(bedroom.id)
    end

    it 'gets all the quests for an item' do
      quests = db.get_quests_for_item(item_1.id)
      expect(quests.size).to eq(2)
      expect(quests[0].class).to eq(WWTD::Quest)
      expect(quests[1].class).to eq(WWTD::Quest)
      quests2 = db.get_quests_for_item(item_1.id)
      expect(quests2.size).to eq(2)
    end

    it "gets all the items in a quest" do
      items = db.get_items_for_quest(quest_2.id)
      expect(items.size).to eq(1)
      expect(items[0].name).to eq(item_1.name)
    end

    it 'gets all the items in a room' do
      items = db.get_items_for_room(bedroom.id)
      expect(items.size).to eq(2)
      expect(items[0].name).to eq(item_1.name)
    end

    it "deletes a record of a quest and an item" do
      expect(db.delete_quest_item(@quest_item_test2.id)).to eq(true)
      quests = db.get_quests_for_item(item_1.id)
      expect(quests.size).to eq(1)
    end
  end

  # characters
  describe 'character' do
    it 'creates a game character with a name, description, strength, questID, roomId, and classification (either person (strength set to 0) or zombie)' do
      expect(character_1.id).to_not be_nil
      expect(character_1.name).to eq('Susie')
      expect(character_1.description).to eq('best friend')
      expect(character_1.class).to eq(WWTD::CharacterNode)
      expect(character_1.room_id).to eq(kitchen.id)
      expect(zombie_1.class).to eq(WWTD::ZombieNode)
      expect(zombie_1.strength).to eq(20)
      expect(zombie_1.quest_id).to eq(quest_1.id)
    end

    it 'retrieves a character' do
      retrieved_character = db.get_character(character_1.id)
      expect(retrieved_character.name).to eq('Susie')
    end

    it 'updates a character' do
      db.update_character(character_1.id, dead: true)
      updated = db.get_character(character_1.id)
      expect(updated.name).to eq('Susie')
      expect(updated.id).to eq(character_1.id)
      expect(updated.dead).to eq(true)

      # check for multiple attributes updated
      db.update_character(character_1.id, dead: false, room_id: 7)
      updated2 = db.get_character(character_1.id)
      expect(updated2.name).to eq('Susie')
      expect(updated2.id).to eq(character_1.id)
      expect(updated2.dead).to eq(false)
      expect(updated2.room_id).to eq(7)
    end

    it 'deletes a character' do
      expect(db.delete_character(character_1.id)).to eq(true)
    end

    it 'gets all the characters for a quest' do
      zombie_1
      character_1
      chars = db.get_all_quest_characters(quest_1.id)
      expect(chars.size).to eq(2)
      chars2 = db.get_all_quest_characters(quest_2.id)
      expect(chars2.size).to eq(0)
    end

    it 'gets all the characters for a room' do
      zombie_1
      character_1
      chars = db.get_all_room_characters(kitchen.id)
      expect(chars.size).to eq(1)
      expect(chars[0].name).to eq("Susie")
      chars = db.get_all_room_characters(bedroom.id)
      expect(chars.size).to eq(1)
      expect(chars[0].name).to eq("bloody clown zombie")
    end

    it 'gets all the characters for a specific room in a quest' do
      zombie_1
      character_1
      chars = db.get_room_and_quest_characters(quest_1.id, kitchen.id)
      expect(chars.size).to eq(1)
      expect(chars[0].name).to eq(character_1.name)
    end
  end

  # players
  describe 'player' do
    it 'creates a player with username, password, description, and default values of strength 100 and dead false' do
      expect(player_1).to be_a WWTD::PlayerNode
      expect(player_1.id).to_not be_nil
      expect(player_1.username).to eq('zombiekilla')
      expect(player_1.password).to eq('eightletters')
      expect(player_1.description).to eq('a zombie killing machine')
      expect(player_1.strength).to eq(100)
      expect(player_1.dead).to eq(false)
    end

    it 'retrieves a player' do
      retrieved_player = db.get_player(player_1.id)
      expect(retrieved_player.username).to eq('zombiekilla')
      expect(retrieved_player.password).to eq('eightletters')
    end

    it "retrieves a player by their username" do
      retrieved_player = db.get_player_by_username(player_1.username)
      expect(retrieved_player.username).to eq('zombiekilla')
      expect(retrieved_player.password).to eq('eightletters')
    end

    it 'updates a player' do
      db.update_player(player_1.id, strength: 50)
      updated_player = db.get_player(player_1.id)
      expect(updated_player.username).to eq('zombiekilla')
      expect(updated_player.password).to eq('eightletters')
      expect(updated_player.description).to eq('a zombie killing machine')
      expect(updated_player.strength).to eq(50)
      expect(updated_player.dead).to eq(false)

      # Checking that it updates multiple attributes at once
      db.update_player(player_1.id, strength: 75, room_id: 2)
      update2 = db.get_player(player_1.id)
      expect(update2.username).to eq('zombiekilla')
      expect(update2.strength).to eq(75)
      expect(update2.room_id).to eq(2)
    end

    it 'deletes a player' do
      expect(db.delete_player(player_1.id)).to eq(true)
    end

    it 'gets all players' do
      player_1
      player_2
      players = db.get_all_players
      expect(players.size).to eq(2)
    end
  end

  # items
  describe 'item' do
    it "creates a item with a name, description, performable actions, room_id, a parent item id (0 if no parent), and classification (either item or weapon)" do
      expect(item_1.id).to_not be_nil
      expect(item_1.room_id).to eq(1)
      expect(item_1.classification).to eq('item')
      expect(item_1.description).to eq('yummy red apple')
      expect(item_1.name).to eq('apple')
      expect(item_1.parent_item).to eq(0)
      expect(weapon_1.classification).to eq('weapon')
      expect(weapon_1.actions).to eq('take, stab, cut')
      expect(weapon_1.parent_item).to eq(item_1.id)
    end

    it 'retrieves a item' do
      retrieved_item = db.get_item(item_1.id)
      expect(retrieved_item.id).to eq(item_1.id)
      expect(retrieved_item.name).to eq('apple')
    end

    it 'updates a item' do
      db.update_item(item_1.id, description: "gross wormy apple", actions: 'throw', room_id: nil)
      updated = db.get_item(item_1.id)
      expect(updated.name).to eq('apple')
      expect(updated.id).to eq(item_1.id)
      expect(updated.description).to eq('gross wormy apple')
      expect(updated.actions).to eq('throw')
      expect(updated.room_id).to be_nil
    end

    it 'deletes a item' do
      expect(db.delete_item(item_1.id)).to eq(true)
    end
  end

  describe 'room' do
    it 'creates a room with a name, description, id, and default values for all directions and all directions access' do
      expect(kitchen.id).to_not be_nil
      expect(kitchen.description).to eq('a bright sunny room with food')
      expect(kitchen.name).to eq('kitchen')
      expect(kitchen.north).to eq(nil)
      expect(kitchen.south).to eq(nil)
      expect(kitchen.east).to eq(nil)
      expect(kitchen.west).to eq(nil)
      expect(kitchen.canN).to eq(true)
      expect(kitchen.canS).to eq(true)
      expect(kitchen.canE).to eq(true)

      # testing non-default settings
      expect(bedroom.north).to eq(kitchen.id)
      expect(bedroom.canW).to eq(false)
    end

    it 'retrieves a room' do
      retrieved_room = db.get_room(kitchen.id)
      expect(retrieved_room).to be_a(WWTD::RoomNode)
      expect(retrieved_room.id).to_not be_nil
      expect(retrieved_room.description).to eq('a bright sunny room with food')
      expect(retrieved_room.name).to eq('kitchen')
    end

    it 'updates a room' do
      db.update_room(kitchen.id, description: "a suddenly dark and gloomy place", south: bedroom.id, canN: false)
      updated = db.get_room(kitchen.id)
      expect(updated.id).to eq(kitchen.id)
      expect(updated.description).to eq("a suddenly dark and gloomy place")
      expect(updated.south).to eq(bedroom.id)
      expect(updated.canN).to eq(false)
      expect(updated.name).to eq('kitchen')
    end

    it 'deletes a room' do
      expect(db.delete_room(kitchen.id)).to eq(true)
    end
  end

  # questCharacters join table (state table for players)
  describe 'questCharacters' do
    before(:each) do
      @quest_character1 = db.create_quest_character(player_id: player_1.id, character_id: character_1.id, quest_id: quest_1.id, room_id: kitchen.id)
      @quest_character2 = db.create_quest_character(player_id: player_2.id, character_id: character_1.id, quest_id: quest_1.id, room_id: kitchen.id)
      @quest_character3 = db.create_quest_character(player_id: player_1.id, character_id: zombie_1.id, quest_id: quest_1.id, room_id: bedroom.id)
    end

    it 'creates a record that stores a character id, quest_id, room _id, and player id (acts as a game state saver)' do
      expect(@quest_character1.id).to_not be_nil
      expect(@quest_character1.player_id).to eq(player_1.id)
      expect(@quest_character2.quest_id).to eq(quest_1.id)
      expect(@quest_character3.character_id).to eq(zombie_1.id)
      expect(@quest_character3.room_id).to eq(bedroom.id)
    end

    it 'returns an array of all the characters for a player and quest' do
      chars = db.get_players_quest_characters(player_1.id, quest_1.id)
      chars2 = db.get_players_quest_characters(player_2.id, quest_1.id)
      expect(chars.size).to eq(2)
      expect(chars2.size).to eq(1)
      p chars
      expect(chars2[0].class).to eq(WWTD::CharacterNode)
    end

    # may not need
    # xit 'returns all the characters for a room' do
    # end

    it 'deletes a record of a quest and character for a player' do
      expect(db.delete_quest_character(player_1.id, character_1.id)).to eq(true)
    end

    it 'deletes all records for a player' do
      db.delete_all_quest_characters(player_1.id, quest_1.id)
      expect(db.get_players_quest_characters(player_1.id, quest_1.id).size).to eq(0)
    end
  end

  # inventory join table
  describe 'inventory' do
    describe 'createNewInventoryItem' do
      before(:each) do
        room_item1
        room_item2
        @inventory_item = db.create_inventory(player_id: player_1.id, quest_id: quest_1.id, item_id: weapon_1.id)
      end

      it 'successfully creates a record of a userId and itemId/adds an item to a persons inventory' do
        expect(@inventory_item.id).to_not be_nil
        expect(@inventory_item.player_id).to eq(player_1.id)
      end

      it 'deletes that item from the room_items table for that player' do
        expect(db.get_player_room_items(player_1.id, kitchen.id).size).to eq(1)
      end
    end

    xit 'gets all the items in a persons inventory' do
      inventory = db.get_player_inventory(player_1.id)
      expect(inventory.size).to eq(1)
      expect(inventory[0].class).to eq(WWTD::ItemNode)
    end

    xit 'removes a record from a persons inventory' do
      db.delete_inventory_item(player_1.id, weapon_1.id)
      inventory = db.get_player_inventory(player_1.id)
      expect(inventory.size).to eq(0)
    end


    xit 'deletes all records for a player' do
      db.create_inventory(player_1.id, quest_1.id, kitchen.id, item_1.id)
      db.delete_all_inventory(player_1.id)
      inventory = db.get_player_inventory(player_1.id)
      expect(inventory.size).to eq(0)
    end
  end

  # roomItems join table
  describe 'roomItems' do
    before(:each) do
      room_item1
      room_item2
    end
    it 'successfully creates a record of items that are in each room for a player (room, player, and item ids) and returns true' do
      expect(room_item1.id).to_not be_nil
      expect(room_item2.id).to_not be_nil
    end

    it 'gets the items left in a room for a player' do
      items_left = db.get_player_room_items(player_1.id, kitchen.id)
      expect(items_left.size).to eq(2)
      expect(items_left[0].class).to eq(WWTD::ItemNode)
    end

    xit 'gets all the items left in a quest for a player' do
      items_left = db.get_player_quest_items(player_1.id, quest_1.id)
      expect(items_left.size).to eq(2)
      expect(items_left.include?(item_1)).to eq(true)
      expect(items_left.include?(weapon_1)).to eq(true)
    end

    xit 'gets all items left for a player in quests started/completed' do
      items_left = db.get_player_items(player_1.id)
      expect(items_left.size).to eq(2)
    end

    it 'removes a record of an item in a room for a specific player' do
      room_item1
      room_item2
      db.delete_player_room_item(player_1.id, kitchen.id, weapon_1.id)
      items = db.get_player_room_items(player_1.id, kitchen.id)
      expect(items.size).to eq(1)
      expect(items[0].id).to eq(item_1.id)
    end

    xit 'deletes all records for a player for specific quest' do
      db.delete_player_room_items(player_1.id, quest_1.id)
      items = db.get_player_quest_items(player_1.id, quest_1.id)
      expect(items.size).to eq(0)
    end

    xit 'deletes all records for a player' do
      db.delete_all_player_items(player_1.id)
      items = db.get_player_items(player_1.id)
      expect(items.size).to eq(0)
    end
  end

  # questProgress join table
  describe 'questProgress' do
    before(:each) do
      @success = db.create_quest_progress(quest_id: quest_1.id, player_id: player_1.id, complete: false, data: {answer_phone: false, enter_lr: false})
      db.create_quest_progress(quest_id: quest_2.id, player_id: player_1.id, complete: false, data: {kill_zombie: true})
    end
    # make more specific about what record contains
    xit 'creates a record of player progress with quest id, player id, a complete status, and critical quest data (converted to json in database)' do
      expect(@success).to eq(true)
    end

    xit 'can retrieve a particular users progress through a certain quest' do
      quest_1_progress = db.get_quest_progress(player_1.id, quest_1.id)
      expect(quest_1_progress.quest_id).to eq(quest_1_id)
      expect(quest_1_progress.player_id).to eq(player_1.id)
      expect(quest_1_progress.complete). to eq(false)
      expect(quest_1_progress.data).to be_a(Hash)
      expect(quest_1_progress.data[answer_phone]).to eq(false)
      expect(quest_1_progress.data[enter_lr]).to eq(false)
    end

    xit 'returns all records for a player' do
      quests = db.get_player_quests(player_1.id)
      expect(quests.size).to eq(2)
    end

    xit 'returns the latest quest for a player' do
      latest_quest = db.get_latest_quest(player_1.id)
      expect(latest_quest.id).to eq(quest_2.id)
    end

    xit 'deletes a record' do
      db.delete_quest_progress(player_1.id, quest_1.id)
      expect(db.get_quest_progress(player_1.id, quest_1.id)).to eq(nil)
    end

    xit 'deletes all records for a user' do
      db.delete_player_quests(player_1.id)
      expect(db.get_player_quests(player_1.id)).to eq([])
    end

    xit 'can be updated' do
      db.update_quest_progress(player_1.id, quest_1.id, complete: true)
      updated = db.get_quest_progress(player_1.id, quest_1.id)
      expect(updated.complete).to eq(true)
    end
  end
end
