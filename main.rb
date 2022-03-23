require 'json'
require 'httparty'

class JsonGetter
    include HTTParty
    base_uri "raw.githubusercontent.com/CodyCodes95/kahoot_kompanion/master/"
    def getter
        self.class.get('/scoreboard.json')
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
    basedir = '.'
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

def quiz_loader(quiz)
    score = 0
    current_question = 0
    current_quiz = JSON.load_file(quiz.to_s, symbolize_names: true)
    current_quiz.each do |question|
        system "clear"
        puts question[:question]
        questions_random = [question[:correct], question[:answer2], question[:answer3], question[:answer4]].shuffle!
        questions_random.each_with_index do |question, i|
            puts "#{i + 1}. #{question}"
        end
        current_question += 1
        puts "Enter your answer"
        answer = gets.chomp.to_i
        if question[:correct] == questions_random[answer - 1]
            score += 1
            puts "CORRECT!"
        else
            puts "Wrong. The correct answer was #{question[:correct]}"
        end
        if current_question == current_quiz.length
            puts "Quiz finished! You scored #{score} out of #{current_quiz.length}."
            puts "Press enter to exit"
            gets
        else
            puts "Your current score is #{score}/#{current_quiz.length}"
            puts "Press enter to continue to the next question"
            gets
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
    system "clear"
    puts "Welcome to the Kahoot Kompanion! Enter what you would like to do below"
    puts "1. View leaderboard"
    puts "2. Quiz Menu"
    puts "3. Exit"
    input = gets.chomp.to_i
    case input
    when 1
        leaderboard_menu = true
        while leaderboard_menu == true
            # puts "Please congragulate our most recent winner, #{last_winner}"
            puts "What would you like to do?"
            puts "1. Placement summary"
            puts "2. Placement details"
            puts "3. Back"
            choice = gets.chomp.to_i
            if choice == 1
                menu = "summary"
                system "clear"
                leaderboard_display(players, menu)
            elsif choice == 2
                menu = "details"
                system "clear"
                leaderboard_display(players, menu)
            elsif choice == 3
                leaderboard_menu = false
            else
                puts "Incorrect input"
            end
        end

    when 2
        quiz_menu = true
        while quiz_menu == true
            system "clear"
            puts "Would you like to"
            puts "1. Play an existing quiz"
            puts "2. Create a new quiz"
            input = gets.chomp.to_i
            if input == 1
                clear
                puts "Enter the quiz you would like to play"
                quiz_getter.each_with_index { |quiz, i| puts "#{i + 1} #{quiz}" }
                answer = gets.chomp.to_i
                quiz_name = quiz_getter[answer - 1]
                quiz_loader(quiz_name)
            elsif input == 2
                quiz_maker
            end
        end
    when 3
        quit = true
    end
end
