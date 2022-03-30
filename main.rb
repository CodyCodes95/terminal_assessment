# GEMS
require 'json'
require 'httparty'
require 'colorize'
require "tty-prompt"
require 'ruby2d'
require './methods'
require './classes'

# GLOBAL
prompt = TTY::Prompt.new
basedir = '.'
song = Music.new('song.mp3')
# players = []
# class_room = JsonGetter.new
# players = JSON.parse(class_room.get, symbolize_names:true)
quit = false
menu_selections = [
  { message: "Welcome to the Kahoot Kompanion! Enter what you would like to do below",
    selections: ["Quiz Menu", "View Leaderboard", "Exit"] },
  { message: "What would you like to", selections: ["Play an existing quiz", "Create a new quiz", "Back"] },
  { message: "What would you like to do?", selections: ["Placement summary", "Placement details", "Exit"] },
  { message: "Which class would you like to view?", selections: %w[Standard Accelerated] },
  { message: "What would you like to do?",
    selections: ["Change class", "Add daily winners", "Modify daily leaderboard", "Modify highscores"] }
]

case ARGV[0]
when "-admin"
    clear_term
    ARGV.clear
    admin_menu = true
    while admin_menu == true
        prompt = TTY::Prompt.new
        pw = prompt.ask("Please enter the admin password, or type quit to exit", echo: false)
        if pw == "plaintextpasswordlol"
            menu = menu_selections[4][:selections]
            case input_prompt(menu_selections[4])
            when menu[0]

            when menu[1]
            puts "Please enter the name of todays champion"
            champ = gets.chomp.capitalize
            puts "Please enter todays runner up"
            runner_up = gets.chomp.capitalize
            puts "Enter today's third place player"
            third = gets.chomp.capitalize
            score_adder(champ, runner_up, third, players)
            File.write('scoreboard_hash.json', JSON.pretty_generate(winners))
            when menu[2]

            when menu[3]

            end
        elsif pw == "quit"
            admin_menu = false
            quit = true
        else
            puts "Password incorrect please try again"
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
        quiz_menu = true
        while quiz_menu == true
            clear_term
            menu = menu_selections[1][:selections]
            case input_prompt(menu_selections[1])
            when menu[0]
                clear_term
                quiz_name = prompt.multi_select("Select the quiz you would like to play", quiz_getter)
                begin
                quiz_loader(quiz_name[0])
                rescue AlreadyPlayedError => e
                    puts e.message
                    retry
                end
            when menu[1]
                quiz_maker
            when menu[2]
                quiz_menu = false
            end
        end

    when menu[1]
        leaderboard_menu = true
        while leaderboard_menu == true
            menu = menu_selections[2][:selections]
            players = JSON.load_file("#{input_prompt(menu_selections[3]).downcase}.json")
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

    when menu[2]
        quit = true
    end
end
