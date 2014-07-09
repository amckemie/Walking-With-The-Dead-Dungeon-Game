# <b>Walking with the Dead: A Text-Based Game</b>

<b>Description:</b> Walking with the Dead is a throw back to the popular 80's dungeon games, also known as interactive fiction games, such as Zork. This particular game is a single-player, text-based gameAfter signing up, players will be given an introductory text description of the room they are in. From there they will be able to type in commands to interact with the world. Some basic things that players will be able to do include moving from room to room, picking up and interacting with objects, and fighting opponents.

Walking with the Dead utilizes a relational database to create the 'world of the game' and to store all player's ongoing progress throughout the game. Through the use of the relational database, player's game state is constantly stored and updated, allowing them to exit the game at any point and start right where they left off the next time they log in.

<b>Author:</b> Ashley McKemie

<b>Tech Stack:</b> Currently, the application utilizes Ruby, PostgresSQL, ActiveRecord, Highline, Colorize, Asciiart, and Bcrypt

<b>Version:</b> 1.0

<b>Current Implementation:</b> Terminal Client

<b>Credits:</b> Robert Kirkman and the creators of The Walking Dead

-----------------------------------------------------------------------------------------------------------------------

## <b>Game Story</b>

Set sometime in the future, in a time where the zombie apocalypse has already happened, but (theoretically) been cured, you are a technician at a local hospital, where many of your good friends also work. Several years ago, the ZV virus tore through the world, threatening the lives of all humans. Fortunately, some very smart scientists found a 'cure' for the virus. When injected within a few hours of being bitten, scratched, or otherwise infected, a person will not turn into a zombie and should remain human for the rest of their life.

At the start of the game, you are awoken to a phone call on your day off from work. From there, it is your choice how you go about your day... choose to sleep in, answer, get up without answering (it may be work after all), or test out any other options.

-----------------------------------------------------------------------------------------------------------------------

## Basic Commands

-- help : Shows list of certain game commands

-- look : Displays current location

-- N/E/S/W (North, East, South, West) : Sends player in that direction (if possible)

-----------------------------------------------------------------------------------------------------------------------

#### Status: This game is currently being developed. Version 1.0 is playable in any terminal by running Ruby. Version 1.5 will expand upon the world, offering more quests, rooms to explore, zombies to fight, and more! Version 2.0 is tentatively planned to have a basic web interface and be delivered through Sinatra.
-----------------------------------------------------------------------------------------------------------------------

### To currently play the game on your own computer:

1) Clone this repo
2) Run 'bundle exec ruby terminal_client.rb' in your terminal from the directory where you cloned the project to

