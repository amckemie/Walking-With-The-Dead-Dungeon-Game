require 'bcrypt'

module WWTD
  class SignUp < UseCase
    include WWTD::StartNewQuest

    def run(params)
      result = validate_params(params) do
        allow :username, :password, :description
        validates :username, presence: true
        validates :password, presence: true
        validates :description, presence: true
      end

      if !result.valid?
        return failure(:invalid_params, :reasons => result.errors.messages)
      else
        player = WWTD.db.get_player_by_username(params[:username])
        if player && player.username
          return failure(:invalid_params, :reasons => { :username => ["is already taken"] })
        else
          password = params.delete(:password)
          password_digest = BCrypt::Password.create(password)
          params[:password_digest] = password_digest
          first_room = WWTD.db.get_first_room
          # Creating player
          new_player = WWTD.db.create_player(username: params[:username], password: params[:password_digest], description: params[:description], room_id: first_room.id)
          # Creating their first questProgress, roomItems, questCharacters, and unique rooms
          start_new_quest?(first_room, new_player)
          # Putting the cell phone in their inventory (first item)
          first_item = WWTD.db.get_first_item
          WWTD::AddToInventory.run(new_player, first_item)
          return success(:player => new_player, :message => "Player successfully signed up.")
        end
      end
    end
  end
end
