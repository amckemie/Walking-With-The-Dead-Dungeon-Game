require 'bcrypt'

module WWTD
  class SignUp < UseCase
    def run(params)
      result = validate_params(params) do
        allow :username, :password, :description, :room_id
        validates :username, presence: true
        validates :password, presence: true, :length => {minimum: 8}
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
          new_player = WWTD.db.create_player(username: params[:username], password: params[:password_digest], description: params[:description])
          return success(:player => new_player, :message => "Player successfully signed up.")
        end
      end
    end
  end
end
