require 'spec_helper'

describe WWTD::ActiveRecordDatabase do
  # Clearing tables for testing
  before { db.clear_tables }
  let(:db) {subject}
  let(:player_1) {db.create_player(username: 'zombiekilla', password: '123abc', description: 'a zombie killing machine')}
  let(:game_person_1) {db.create_person(name: 'Susie', description: "best friend", roomId: 10)}
  let(:zombie_1) {db.create_zombie(roomId: 2, description: 'a scary zombie', strength: 20)}
  let(:item_1) {db.create_item(name: 'apple', description: "yummy red apple", actions: 'eat, take', location_id: 1)}
  let(:weapon_1) {db.create_weapon(name: 'sword', description: "a sharp pointy thing", actions: 'stab, cut', location_id: 4)}
  let(:kitchen) {db.create_room(name: 'kitchen', description: 'a bright sunny room with food')}
  let(:bedroom) {db.create_room(name: 'bedroom', description: 'a place to sleep', north: kitchen, canN: true)}

  describe 'player' do
    it 'creates a player with default values of strength 100, roomID 1, and dead false' do
      expect(player_1).to be_a WWTD::PersonNode
      expect(player_1.id).to_not be_nil
      expect(player_1.username).to eq('zombiakilla')
      expect(player_1.has_password? '123abc').to eq(true)
      expect(player_1.description).to eq('a zombie killing machine')
      expect(player_1.strength).to eq(100)
      expect(player_1.roomId).to eq(1)
      expect(player_1.dead).to eq(false)
    end

    xit 'retrieves a player' do
      retrieved_player = db.get_player(player_1.id)
      expect(retrieved_player.username).to eq('zombiekilla')
      expect(retrieved_player.password).to eq('123abc')
    end

    xit "retrieves a player by their username" do
      retrieved_player = db.get_player_by_username(player_1.username)
      expect(retrieved_player.username).to eq('zombiekilla')
      expect(retrieved_player.password).to eq('123abc')
    end

    xit 'updates a player' do
      db.update_player(player_1.id, strength: 50)
      updated_player = db.get_player(player_1.id)
      expect(updated_player.username).to eq('zombiakilla')
      expect(updated_player.password).to eq('123abc')
      expect(updated_player.description).to eq('a zombie killing machine')
      expect(updated_player.strength).to eq(50)
      expect(updated_player.roomId).to eq(1)

      # Checking that it updates multiple attributes at once
      db.update_player(strength: 75, roomId: 2)
      update2 = db.get_player(player_1.id)
      expect(update2.username).to eq('zombiakilla')
      expect(update2.strength).to eq(75)
      expect(update2.roomId).to eq(2)
    end

    xit 'deletes a player' do
      db.delete_player(player_1.id)
      expect(db.get_player(player_1.id)).to eq(nil)
    end
  end

  describe 'zombies' do
    xit 'creates a zombie' do
      expect(zombie.id).to_not be_nil
      expect(zombie.description).to eq('a scary zombie')
      expect(zombie.strength).to eq(20)
      expect(zombie.roomId).to eq(2)
    end

    xit 'retrieves a zombie' do
      retrieved_zombie = db.get_zombie(zombie.id)
      expect(retrieved_zombie.id).to eq(zombie.id)
      expect(retrieved_zombie.description).to eq('a scary zombie')
    end

    xit 'updates a zombie' do
      db.update_zombie(zombie_1.id, killed: true)
      updated = db.get_zombie(zombie_1.id)
      expect(updated.id).to eq(zombie_1.id)
      expect(updated.description).to eq('a scary zombie')
      expect(updated.killed).to eq(true)
    end

    xit 'deletes a zombie' do
      db.delete_zombie(zombie_1.id)
      expect(db.get_zombie(zombie_1.id)).to eq(nil)
    end

    xit 'returns zombies by room ID' do
      zombie_1
      zombie_2 = db.create_zombie(description: 'scary zombie 2', strength: 10, roomId: 2)
      zombie_3 = db.create_zombie(description: 'scary zombie 3', strength: 15, roomId: 5)
      zombies_room_2 = db.get_zombies_by_room(2)
      zombies_room_5 = db.get_zombies_by_room(5)
      expect(zombies_room_2.size).to eq(2)
      expect(zombies_room_2.include?(zombie_2)).to eq(true)
      expect(zombies_room_2.include?(zombie_1)).to eq(true)
      expect(zombies_room_5.size).to eq(1)
      expect(zombies_room_2.include?(zombie_3)).to eq(true)
    end
  end

  describe 'people' do
    xit 'creates a person that has a default infected attribute of false' do
      expect(game_person_1.id).to_not be_nil
      expect(game_person_1.name).to eq('Susie')
      expect(game_person_1.description).to eq('best friend')
      expect(game_person_1.infected).to eq(false)
      expect(game_person_1.roomId).to eq(10)
    end

    xit 'retrieves a person' do
      retrieved_person = db.get_person(game_person_1.id)
      expect(retrieved_person.name).to eq('Susie')
    end

    xit 'updates a person' do
      db.update_person(game_person_1.id, infected: true)
      updated = db.get_person(game_person_1.id)
      expect(updated.name).to eq('Susie')
      expect(updated.id).to eq(game_person_1.id)
      expect(updated.infected).to eq(true)

      # check for multiple attributes updated
      db.update_person(game_person_1.id, infected: false, roomId: 7)
      updated2 = db.get_person(game_person_1.id)
      expect(updated2.name).to eq('Susie')
      expect(updated2.id).to eq(game_person_1.id)
      expect(updated2.infected).to eq(false)
      expect(updated2.roomId).to eq(7)
    end

    xit 'deletes a person' do
      db.delete_person(game_person_1.id)
      expect(db.get_person(game_person_1.id)).to eq(nil)
    end

    xit 'returns people by room ID' do
      game_person_1
      person2 = db.create_person(name: 'John', description: "not a friend", roomId: 10)
      person3 = db.create_person(name: 'Jack', description: "old guy", roomId: 8)
      room_10_people = db.get_people_by_room(10)
      room_8_people = db.get_people_by_room(8)
      expect(room_10_people.size).to eq(2)
      expect(room_8_people.size).to eq(1)
      expect(room_10_people.include?(game_person_1)).to eq(true)
      expect(room_10_people.include?(person2)).to eq(true)
      expect(room_8_people.include?(person3)).to eq(true)
    end
  end

  describe 'items' do
    xit "creates a item with default values of type 'item' and location_type WWTD::RoomNode" do
      expect(item_1.id).to_not be_nil
      expect(item_1.type).to eq('item')
      expect(item_1.location_type).to eq(WWTD::RoomNode)
      expect(item_1.location_id).to eq(1)
      expect(item_1.description).to eq('yummy red apple')
      expect(item_1.actions).to eq('eat, take')
      expect(item_1.name).to eq('apple')
    end

    xit 'retrieves a item' do
      retrieved_item = db.get_item(item_1.id)
      expect(retrieved_item.id).to eq(item_1.id)
      expect(retrieved_item.name).to eq('apple')
    end

    xit 'updates a item' do
      db.update_item(item_1.id, description: "gross wormy apple", actions: 'throw')
      updated = db.get_item(item_1.id)
      expect(updated.name).to eq('apple')
      expect(updated.id).to eq(item_1.id)
      expect(updated.description).to eq('gross wormy apple')
      expect(updated.actions).to eq('throw')
    end

    xit 'deletes a item' do
      db.delete_item(item_1.id)
      expect(db.get_item(item_1.id)).to eq(nil)
    end

    xit 'returns items by room ID' do
      item2 = db.create_item(name: 'shirt', description: "threadbare", actions: 'wear, put on', location_id: 1)
      item3 = db.create_item(name: 'skirt', description: "full and pretty", actions: 'wear, put on', location_id: 3)
      room_1_items = db.get_items_by_room(10)
      room_3_items = db.get_items_by_room(8)
      expect(room_1_items.size).to eq(2)
      expect(room_3_items.size).to eq(1)
      expect(room_1_items.include?(item_1)).to eq(true)
      expect(room_1_items.include?(item2)).to eq(true)
      expect(room_3_items.include?(item3)).to eq(true)
    end
  end

  describe 'weapons' do
    xit 'creates a weapon with default values of type "weapon" and location_type WWTD::RoomNode' do
      expect(weapon_1.id).to_not be_nil
      expect(weapon_1.type).to eq('weapon')
      expect(weapon_1.location_type).to eq(WWTD::RoomNode)
      expect(weapon_1.location_id).to eq(4)
      expect(weapon_1.description).to eq('a sharp pointy thing')
      expect(weapon_1.actions).to eq('stab, cut')
      expect(weapon_1.name).to eq('sword')
    end

    xit 'retrieves a weapon' do
      retrieved_weapon = db.get_weapon(weapon_1.id)
      expect(retrieved_weapon.id).to eq(weapon_1.id)
      expect(retrieved_weapon.name).to eq('sword')
    end

    xit 'updates a weapon' do
      db.update_weapon(weapon_1.id, description: "a dully useless object", actions: 'throw, drop')
      updated = db.get_weapon(weapon_1.id)
      expect(updated.name).to eq('sword')
      expect(updated.id).to eq(weapon_1.id)
      expect(updated.description).to eq("a dully useless object")
      expect(updated.actions).to eq('throw, drop')
    end

    xit 'deletes a weapon' do
      db.delete_weapon(weapon_1.id)
      expect(db.get_weapon(weapon_1.id)).to eq(nil)
    end

    xit 'returns weapons by room ID' do
      weapon2 = db.create_weapon(name: 'bat', description: "babe ruth", actions: 'hit', location_id: 4)
      weapon3 = db.create_weapon(name: 'crossbow', description: "awesome and badass", actions: 'shoot, fire', location_id: 1)
      room_4_weapons = db.get_weapons_by_room(4)
      room_1_weapons = db.get_weapons_by_room(1)
      expect(room_4_weapons.size).to eq(2)
      expect(room_1_weapons.size).to eq(1)
      expect(room_4_weapons.include?(weapon_1)).to eq(true)
      expect(room_4_weapons.include?(weapon2)).to eq(true)
      expect(room_1_weapons.include?(weapon3)).to eq(true)
    end
  end

  describe 'rooms' do
    xit 'creates a room' do
      expect(kitchen.id).to_not be_nil
      expect(kitchen.description).to eq('a bright sunny room with food')
      expect(kitchen.name).to eq('kitchen')
    end

    xit 'retrieves a room' do
      retrieved_room = db.get_room(kitchen.id)
      expect(retrieved_room.id).to_not be_nil
      expect(retrieved_room.description).to eq('a bright sunny room with food')
      expect(retrieved_room.name).to eq('kitchen')
    end

    xit 'updates a room' do
      db.update_room(kitchen.id, description: "a suddenly dark and gloomy place", south: bedroom, canN: false)
      updated = db.get_room(kitchen.id)
      expect(updated.id).to eq(kitchen.id)
      expect(updated.description).to eq("a suddenly dark and gloomy place")
      expect(updated.south).to eq(bedroom)
      expect(updated.canN).to eq(true)
      expect(updated.name).to eq('kitchen')
    end

    xit 'deletes a room' do
      db.delete_room(kitchen.id)
      expect(db.get_room(kitchen.id)).to eq(nil)
    end
  end

end

