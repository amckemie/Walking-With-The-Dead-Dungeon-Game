module WWTD
  def self.db
    @__db_instance ||= Database::ActiveRecordDatabase.new
  end
end

require_relative 'wwtd/entities/structure.rb'
require_relative 'wwtd/entities/item.rb'
require_relative 'wwtd/entities/person.rb'
require_relative 'wwtd/entities/zombie.rb'
require_relative 'wwtd/database/active_record_db.rb'
require_relative 'wwtd/commands/fight.rb'
require_relative 'wwtd/commands/sign_in.rb'
require_relative 'wwtd/commands/sign_up.rb'
require_relative 'wwtd/commands/unlock_door.rb'


