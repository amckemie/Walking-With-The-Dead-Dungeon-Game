require 'highline/import'
require_relative './lib/wwtd.rb'

module WWTD
  class TerminalClient
    def initialize
      @db = WWTD.db
      puts "Welcome to Walking with the Dead (name credits definitively go to Walking with the Dead and Robert Kirkman."
      login_info = ask("Please enter sign in if you have played before and sign up if you are new")
      login(login_info)
    end

    def login(input)
      un = ask("Enter your username: ")
      pw = ask("Enter your password:  ") { |q| q.echo = '*' }
      if input == 'sign in'
        result = WWTD::SignIn.new.run(username: un, password: pw)
        if result.success?
          # send to run method and run current room's description
        else
          errors = errors_helper(result.reasons.values)
          p "Sorry. Your log-in was not successful for these reasons: " + errors
          response = ask("Please type sign in to try again or sign up to create an account. ")
          login(response)
        end
      elsif input == 'sign up'
        desc = ask("Enter a description for your player: ")
        result = WWTD::SignUp.new.run(username: un, password: pw, description: desc)
        if result.success?
          @db.create
        else
          errors = errors_helper(result.reasons.values)
          p "Sorry, your sign up was not successful for these reasons: " + errors + ". If you're going to try to fight zombies, you may want to sharpen up those skills..."
          response = ask("Please type sign up to try again or sign in to log into an account. ")
          login(response)
        end
      elsif input == 'exit'
        p "Scared of zombies I see...Well maybe next time you'll muster the courage to play."
      else
        response = ask("I'm sorry, I don't recognize that command. Please type sign in or sign up to play or exit to leave the game.")
        login(response)
      end
    end

    def play_game()
    end

    def errors_helper(errors_arr)
      result = ''
      return errors_arr.flatten[0] if errors_arr.length == 1
      errors_arr.flatten.each do |i|
        result += i += " and "
      end
      result.slice!(-4, 5)
    end

  end
end

WWTD::TerminalClient.new
