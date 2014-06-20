module WWTD
  class SignUp < UseCase
    def run(params)
      result = validate_params(params) do
        allow :username, :password, :description
        validates :username, presence: true
        validates :password, presence: true, :length => {minimum: 8}
        validates :description, presence: true
      end

      if !result.valid?
        return failure(:invalid_params, :reasons => result.errors.messages)
      elsif
        player = WWTD.db.get_player_by_username(params[:username])
        if player.username
          return failure()
        else
          player = WWTD.db.create_player(username: params[:username], password: params[:password], description: params[:description])
          return success(:player => player, :message => "Player successfully signed up.")
        end
      end
    end
  end
end
