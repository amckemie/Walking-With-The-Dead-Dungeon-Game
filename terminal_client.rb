require 'highline/import'
require 'colorize'
require 'asciiart'
require_relative './lib/wwtd.rb'

module WWTD
  class TerminalClient
    def initialize
      @db = WWTD.db
      @player = nil
      puts "        ▄ ▄   ██   █    █  █▀ ▄█    ▄     ▄▀        ▄ ▄   ▄█    ▄▄▄▄▀ ▄  █        ▄▄▄▄▀ ▄  █ ▄███▄       ██▄   ▄███▄   ██   ██▄
       █   █  █ █  █    █▄█   ██     █  ▄▀         █   █  ██ ▀▀▀ █   █   █     ▀▀▀ █   █   █ █▀   ▀      █  █  █▀   ▀  █ █  █  █
      █ ▄   █ █▄▄█ █    █▀▄   ██ ██   █ █ ▀▄      █ ▄   █ ██     █   ██▀▀█         █   ██▀▀█ ██▄▄        █   █ ██▄▄    █▄▄█ █   █
      █  █  █ █  █ ███▄ █  █  ▐█ █ █  █ █   █     █  █  █ ▐█    █    █   █        █    █   █ █▄   ▄▀     █  █  █▄   ▄▀ █  █ █  █
       █ █ █     █     ▀  █    ▐ █  █ █  ███       █ █ █   ▐   ▀        █        ▀        █  ▀███▀       ███▀  ▀███▀      █ ███▀
        ▀ ▀     █        ▀       █   ██             ▀ ▀                ▀                 ▀                               █
               ▀                                                                                                        ▀          ".red.on_black

      zombie = AsciiArt.new("./lib/assets/zombie.jpeg")
      puts zombie.to_ascii_art
      puts "Welcome to Walking with the Dead, a single-player, text-based game! Name credits definitively go to the Walking Dead and Robert Kirkman.".white.on_light_blue
      puts "Enter if you dare".white.on_light_blue
      login_info = ask("Please enter sign in if you have played before and sign up if you are new")
      login(login_info)
    end

    def login(input)
      if input == 'quit'
        puts "Scared of zombies I see...Well maybe next time you'll muster up the courage to play.".white.on_light_red.bold
      else
        un = ask("Enter your username: ")
        pw = ask("Enter your password:  ") { |q| q.echo = '*' }
        if input == 'sign in'
          result = WWTD::SignIn.new.run(username: un, password: pw)
          if result.success?
            @player = result.player
            current_quest = WWTD.db.get_latest_quest(result.player.id)
            current_room = WWTD.db.get_room(@player.room_id)
            puts "You are currently in: ".white.on_light_blue + current_room.name.white.on_light_blue
            response = ask(" ")
            check_user_input(response)
          else
            errors = errors_helper(result.reasons.values)
            puts "Sorry. Your log-in was not successful for these reasons: ".white.on_yellow.bold + errors.white.on_yellow.bold
            response = ask("Please type sign in to try again or sign up to create an account. ")
            login(response)
          end
        elsif input == 'sign up'
          desc = ask("Enter a description for your player: ")
          result = WWTD::SignUp.new.run(username: un, password: pw, description: desc)
          if result.success?
            # Set @player to new player
            @player = result.player
            # print game introduction text
            game_intro
            response = ask("What would you like to do? ")
            check_user_input(response)
          else
            errors = errors_helper(result.reasons.values)
            puts "Sorry, your sign up was not successful for these reasons: ".white.on_yellow.bold + errors.white.on_yellow.bold + ". If you're going to try to fight zombies, you may want to sharpen up those skills...".white.on_yellow.bold
            response = ask("Please type sign up to try again or sign in to log into an account. ")
            login(response)
          end
        else
          response = ask("I'm sorry, I don't recognize that command. Please type sign in or sign up to play or exit to leave the game.")
          login(response)
        end
      end
    end

    def check_user_input(response)
      if response.include?('yes') || response == "y"
        quest_id = WWTD.db.get_latest_quest(@player.id).id
        result = WWTD::GameOver.run(@player, quest_id)
        @player = result.player
        game_intro
        puts result.message
        continue_game
      elsif response.include?('quit')
        puts "Goodbye. Come back and try to defeat the zombies soon... BRAAAAAAIIIIIIIINNNNNNNNNNSSSSSSSSSSSSSSSSS".white.on_light_red.bold
      elsif response.include?('help')
        help_menu
        continue_game
      else
        result = WWTD::UserAction.run(@player, response)
        @player = result.player
        if @player.dead
          puts result.message.white.on_red
          play_again = ask("Want to try again? (You can sign in again at a later date also) " )
          check_user_input(play_again)
        else
          puts result.message.white.on_light_blue
          continue_game
        end
      end
    end

    def errors_helper(errors_arr)
      result = ''
      return errors_arr.flatten[0] if errors_arr.length == 1
      errors_arr.flatten.each do |i|
        result += i += " and "
      end
      result.slice!(-4, 5)
    end

    def game_intro
      puts "It's been a little over 2 years since the ZV (Zombiaviridae) virus broke out, causing perfectly normal people to turn into, well for lack of a better word: zombies. Fortunately, and unlike popular comics and movies of the time suggested, it didn't take our brightest minds years to find a cure. It only took around 9 months - thank god. Once a person was infected - through a bite, scratch, or any transfer of bodily fluids - they have to get a shot of the cure within a few hours. As such, everyone carries at least one vial on them at all times. If you inject the medicine within the alloted time frame, it has thus far proven to be effective at stopping ZV.".white.on_light_blue
      puts "You currently work at a major hospital in the area as a pharmaceutical tech. Today is your first full day off in awhile, and you've planned to take full advantage of that by sleeping in at home.".white.on_light_blue
      puts "Damn. Your cell phone is ringing, threatening to make you get up if you choose to answer it. It's probably just work anyways, and who wants to talk to their boss on their day off?".white.on_light_blue
    end

    def help_menu
      puts "I won't be of much help; This is a zombie eat zombie (ahem, person) world, and you have to figure things out for yourself.".white.on_light_blue
      puts "I will tell you the following though:".white.on_light_blue
      puts "You can navigate your way around with the cardinal directions (for ex: North or N)".white.on_light_blue
      puts "You can find out where you are by typing 'where am I'".white.on_light_blue
      puts "You can get a description of your location by typing 'look'".white.on_light_blue
      puts "You can see what items you have on you by typing 'inventory'.".white.on_light_blue
      puts "To quit, type 'quit' ".white.on_light_blue
      puts "God speed.".white.on_light_blue
    end

    def continue_game
      response = ask(" ")
      response.downcase!
      check_user_input(response)
    end
  end
end

WWTD::TerminalClient.new
