module WWTD
  def self.db
    @__db_instance ||= ActiveRecordDatabase.new
  end
end

require_relative './wwtd/entities/room.rb'
require_relative './wwtd/entities/item.rb'
require_relative './wwtd/entities/player.rb'
require_relative './wwtd/entities/character.rb'
require_relative './wwtd/entities/zombie.rb'
require_relative './wwtd/entities/quest.rb'
require_relative './wwtd/entities/quest_progress.rb'
require_relative './wwtd/database/active_record_db.rb'
require_relative './wwtd/modules/start_new_quest.rb'
require_relative './wwtd/database/methods/quest_db.rb'
require_relative './wwtd/database/methods/character_db.rb'
require_relative './wwtd/database/methods/room_db.rb'
require_relative './wwtd/database/methods/item_db.rb'
require_relative './wwtd/database/methods/player_db.rb'
require_relative './wwtd/database/methods/quest_item_db.rb'
require_relative './wwtd/database/methods/quest_characters_db.rb'
require_relative './wwtd/database/methods/inventory_db.rb'
require_relative './wwtd/database/methods/room_item_db.rb'
require_relative './wwtd/database/methods/quest_progress_db.rb'
require_relative './wwtd/database/methods/player_room_db.rb'

require_relative './wwtd/commands/use_case_validations.rb'
require_relative './wwtd/commands/command_class.rb'

require_relative './wwtd/commands/fight.rb'
require_relative './wwtd/commands/sign_in.rb'
require_relative './wwtd/commands/sign_up.rb'
require_relative './wwtd/commands/enter_room.rb'
require_relative './wwtd/commands/add_to_inventory.rb'
require_relative './wwtd/commands/show_inventory.rb'
require_relative './wwtd/commands/user_action.rb'
require_relative './wwtd/commands/use_item.rb'
require_relative './wwtd/commands/use_phone.rb'

# require_relative './commands/unlock_door.rb'


