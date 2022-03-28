# GEMS
require 'json'
require 'httparty'
require 'colorize'
require "tty-prompt"
require 'ruby2d'
require './methods.rb'
require './classes.rb'

# GLOBAL
prompt = TTY::Prompt.new
basedir = '.'
song = Music.new('song.mp3')
class_room = JsonGetter.new
players = JSON.parse(class_room.get_hash, symbolize_names:true )
quit = false
menu_selections = [
  { message: "Welcome to the Kahoot Kompanion! Enter what you would like to do below",
    selections: ["View Leaderboard", "Quiz Menu", "Exit"] },
  { message: "What would you like to", selections: ["Play an existing quiz", "Create a new quiz", "Back"] },
  { message: "What would you like to do?", selections: ["Placement summary", "Placement details", "Exit"] }

]

class InvalidAnswerError < StandardError
    def message
        return "Answer must be a number between 1 and 4"
    end
end

case ARGV[0]
when "-admin"
    ARGV.clear
    admin_menu = true
    while admin_menu == true
        prompt = TTY::Prompt.new
        pw = prompt.ask("Please enter the admin password, or type quit to exit", echo: false)
        if pw == "plaintextpasswordlol"
            winners = score_adder(players)
            File.write('scoreboard_hash.json', JSON.pretty_generate(winners))
        elsif pw == "quit"
            admin_menu = false
            quit = true
        else
            puts "Incorrect password please try again"
        end
    end
    quit = true
when "-help"
    ARGV.clear
    puts "Go find some help"
    puts "Press enter to quit"
    gets
    quit = true
end

while quit == false
    clear_term
    # song.play
    menu = menu_selections[0][:selections]
    case input_prompt(menu_selections[0])
    when menu[0]
        leaderboard_menu = true
        while leaderboard_menu == true
            menu = menu_selections[2][:selections]
            case input_prompt(menu_selections[2])
            when menu[0]
                menu = "summary"
                clear_term
                leaderboard_display(players, menu)
            when menu[1]
                menu = "details"
                clear_term
                leaderboard_display(players, menu)
            when menu[2]
                leaderboard_menu = false
            end
        end

    when menu[1]
        quiz_menu = true
        while quiz_menu == true
            clear_term
            menu = menu_selections[1][:selections]
            case input_prompt(menu_selections[1])
            when menu[0]
                clear_term
                quiz_name = prompt.multi_select("Select the quiz you would like to play", quiz_getter)
                quiz_loader(quiz_name[0])
            when menu[1]
                quiz_maker
            when menu[2]
                quiz_menu = false
            end
        end
    when menu[2]
        quit = true
    end
end
