# GEMS
require 'json'
require 'httparty'
require 'colorize'
require "tty-prompt"

# GLOBAL
prompt = TTY::Prompt.new
basedir = '.'


# Class to grab JSON files from server
class JsonGetter
    include HTTParty
    base_uri "raw.githubusercontent.com/CodyCodes95/kahoot_kompanion/master/"
    def getter
        self.class.get('/scoreboard.json')
    end
end


class InvalidAnswerError < StandardError
    def message
        return "Answer must be a number between 1 and 4"
    end
end

class_room = JsonGetter.new
players = JSON.parse(class_room.getter)

def quiz_maker
    quiz = []
    puts "What would you like to name this quiz?"
    name = gets.chomp
    puts "How many questions would you like to have?"
    quiz_length = gets.chomp.to_i
    i = 0
    while i < quiz_length
        puts "What would you like your question to be?"
        question = gets.chomp
        puts "Enter the correct answer to your question"
        correct_answer = gets.strip
        puts "Enter each fake answer hitting enter between each"
        answer2 = gets.strip
        answer3 = gets.strip
        answer4 = gets.strip
        quiz.push({ question: question, correct: correct_answer, answer2: answer2, answer3: answer3, answer4: answer4 })
        i += 1
    end
    File.write("#{name}_quiz.json", JSON.pretty_generate(quiz))
end

def clear
    return system "clear"
end

def quiz_getter
    files = Dir.glob("*.json")
    i = 1
    all_quiz = []
    files.each do |file|
        if file.include?("quiz")
            all_quiz.push(file)
            i += 1
        end
    end
    return all_quiz
end

def results_getter
    files = Dir.glob("*.json")
    i = 1
    all_results = []
    files.each do |file|
        if file.include?("results")
            all_results.push(file)
            i += 1
        end
    end
    return all_results
end

def quiz_loader(quiz)
    puts "Enter your name"
    name = gets.chomp
    score = 0
    current_question = 0
    highscores = if results_getter.any? { |e| e.include? quiz.slice(0..-10).to_s }
        JSON.load_file("#{quiz.slice(0..-10)}results.json", symbolize_names: true)
                 else
        []
                 end
    current_quiz = JSON.load_file(quiz.to_s, symbolize_names: true)
    current_quiz.each do |question|
        clear
        puts question[:question]
        questions_random = [question[:correct], question[:answer2], question[:answer3], question[:answer4]].shuffle!
        questions_random.each_with_index do |question, i|
            puts "#{i + 1}. #{question}".colorize(:green)
        end
        current_question += 1
        puts "Enter your answer"
        answer = gets.chomp.to_i
        if answer > 5 || answer < 1
            raise InvalidAnswerError
        else
            if question[:correct] == questions_random[answer - 1]
                score += 1
                puts "CORRECT!"
            else
                puts "Wrong. The correct answer was #{question[:correct]}"
            end
            if current_question == current_quiz.length
                puts "Quiz finished! You scored #{score} out of #{current_quiz.length}."
                puts "Press enter to exit"
                already_played = false
                highscores.each do |person|
                    already_played = true if person[:name] == name
                end
                if already_played == true
                    highscores.each do |person|
                        person[:score] = score if person[:name] = name
                    end
                else
                    highscores.push({ name: name, score: score })
                end
                File.write("#{quiz.slice(0..-10)}results.json", JSON.pretty_generate(highscores))
                gets
            else
                puts "Your current score is #{score}/#{current_quiz.length}"
                puts "Press enter to continue to the next question"
                gets
            end
        end
    end
end

def leaderboard_display(arr, menu)
    sorted = arr.clone.sort_by { |player| player[4] }
    sorted.reverse!.each_with_index do |player, i|
        if menu == "summary"
        puts "#{i + 1}. #{player[0]} Score: #{player[4]}"
        elsif menu == "details"
            puts "#{i + 1}. #{player[0]} With #{player[1]} First place wins, #{player[2]} runner up placements and #{player[3]} 3rd placements."
        end
    end
end

def score_adder(first, second, third, arr)
    if arr.any? { |s| s.include?(first) }
    arr.each_with_index do |_player, i|
        arr[i][1] += 1 if arr[i].include?(first)
    end
    else
        arr.push([first, 1, 0, 0, 0])
    end
    if arr.any? { |s| s.include?(second) }
    arr.each_with_index do |_player, i|
        arr[i][2] += 1 if arr[i].include?(second)
    end
    else
        arr.push([second, 0, 1, 0, 0])
    end
    if arr.any? { |s| s.include?(third) }
    arr.each_with_index do |_player, i|
        arr[i][3] += 1 if arr[i].include?(third)
    end
    else
        arr.push([third, 0, 0, 1, 0])
    end

    arr.each_with_index do |_player, i|
            arr[i][4] = ((arr[i][1]) * 3) + (arr[i][2] * 2) + arr[i][3]
    end
end

quit = false
case ARGV[0]
when "-admin"
    ARGV.clear
    admin_menu = true
    while admin_menu == true
    puts "Please enter the password to modify the leaderboard"
    puts "Or type back to navigate back."
    pw = gets.chomp
    if pw == "plaintextpasswordlol"
        puts "Please enter the name of todays champion"
        champ = gets.chomp.capitalize
        puts "Please enter todays runner up"
        runner_up = gets.chomp.capitalize
        puts "Enter today's third place player"
        third = gets.chomp.capitalize
        score_adder(champ, runner_up, third, players)
        File.write('scoreboard.json', JSON.pretty_generate(players))
    elsif pw == "back"
        admin_menu = false
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
    clear
    menu_selections = ["View Leaderboard", "Quiz Menu", "Exit"]
    input = prompt.multi_select("Welcome to the Kahoot Kompanion! Enter what you would like to do below", menu_selections)
    case input
    when [menu_selections[0]]
        leaderboard_menu = true
        while leaderboard_menu == true
            menu_selections = ["Placement summary", "Placement details", "Exit"]
            input = prompt.multi_select("What would you like to do?", menu_selections)
            if input == [menu_selections[0]]
                menu = "summary"
                clear
                leaderboard_display(players, menu)
            elsif input == [menu_selections[1]]
                menu = "details"
                clear
                leaderboard_display(players, menu)
            elsif input == [menu_selections[2]]
                leaderboard_menu = false
            end
        end

    when [menu_selections[1]]
        quiz_menu = true
        while quiz_menu == true
            menu_selections = ["Play an existing quiz", "Create a new quiz", "Back"]
            clear
            input = prompt.multi_select("Would you like to", menu_selections)
            if input == [menu_selections[0]]
                clear
                quiz_name = prompt.multi_select("Select the quiz you would like to play", quiz_getter)
                quiz_loader(quiz_name)
            elsif input == [menu_selections[1]]
                quiz_maker
            elsif input == [menu_selections[2]]
                quiz_menu = false
            end
        end
    when [menu_selections[2]]
        quit = true
    end
end
