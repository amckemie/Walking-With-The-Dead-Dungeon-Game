require 'bcrypt'

module WWTD
  class SignIn < UseCase
    def run(params)
      result = validate_params(params) do
        allow :username, :password
        validates :username, presence: true
        validates :password, presence: true, :length => {minimum: 8}
      end

      if !result.valid?
        return failure(:invalid_params, :reasons => result.errors.messages)
      end

      player = WWTD.db.get_player_by_username(params[:username])
      if !player
        return failure(:invalid_username, :reasons => { :username => ["username not found"] })
      else
        bcrypt_password = BCrypt::Password.new(player.password)
        if bcrypt_password != params[:password]
          return failure(:invalid_password, :reasons => { :password => ['incorrect password']})
        else
          return success(:player => player, :message => "Player successfully signed in.")
        end
      end
    end
  end
end
