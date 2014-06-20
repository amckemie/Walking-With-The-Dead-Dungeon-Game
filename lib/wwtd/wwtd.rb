module WWTD
  def self.db
    @__db_instance ||= ActiveRecordDatabase.new
  end
end

require_relative './entities/structure.rb'
require_relative './entities/item.rb'
require_relative './entities/player.rb'
require_relative './entities/character.rb'
require_relative './entities/zombie.rb'
require_relative './entities/quest.rb'
require_relative './entities/quest_progress.rb'
require_relative './database/active_record_db.rb'
require_relative './database/methods/quest_db.rb'
require_relative './database/methods/character_db.rb'
require_relative './database/methods/room_db.rb'
require_relative './database/methods/item_db.rb'
require_relative './database/methods/player_db.rb'
require_relative './database/methods/quest_item_db.rb'
require_relative './database/methods/quest_characters_db.rb'
require_relative './database/methods/inventory_db.rb'
require_relative './database/methods/room_item_db.rb'
require_relative './database/methods/quest_progress_db.rb'

# require_relative './commands/fight.rb'
# require_relative './commands/sign_in.rb'
# require_relative './commands/sign_up.rb'
# require_relative './commands/unlock_door.rb'


