require 'ostruct'

module WWTD
  class ShowInventory < Command
    def run(player)
      inventory = WWTD.db.get_player_inventory(player.id)
      if inventory.length >= 1
        inventory_string = ""
        inventory.each do |item|
          inventory_string += item.name
          inventory_string += ", "
        end
        inventory_string.slice!(-2, 2)

        return success :message => inventory_string, :player => player
      else
        return failure("Ruh roh. You have no items with you. Might want to fix that...")
      end
    end
  end
end
