# module WWTD
#   def self.db
#     @__db_instance ||= Database::ActiveRecordDatabase.new
#   end
# end

require_relative './entities/structure.rb'
require_relative './entities/item.rb'
require_relative './entities/person.rb'
require_relative './entities/zombie.rb'
require_relative './database/active_record_db.rb'
require_relative './commands/fight.rb'
require_relative './commands/sign_in.rb'
require_relative './commands/sign_up.rb'
require_relative './commands/unlock_door.rb'


