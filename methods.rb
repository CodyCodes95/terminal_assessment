require './classes.rb'

def clear_term
    system"clear"
end

def input_prompt(menu)
    prompt = TTY::Prompt.new
    input = prompt.multi_select(menu[:message], menu[:selections])
    return input[0]
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

def quiz_loader(quiz)
    prompt = TTY::Prompt.new
    highscores = if results_getter.any? { |e| e.include? quiz.slice(0..-10).to_s }
        JSON.load_file("#{quiz.slice(0..-10)}results.json", symbolize_names: true)
                 else
        []
                 end
    puts "Enter your name"
    name = gets.chomp
    already_played = false
     highscores.each do |person|
        already_played = true if person[:name] == name
    end
    raise(AlreadyPlayedError) if already_played == true
        puts "You've already played this quiz!"
    score = 0
    current_question = 0
    current_quiz = JSON.load_file(quiz.to_s, symbolize_names: true)
    current_quiz.each do |question|
        clear_term
        questions_random = [question[:correct], question[:answer2], question[:answer3], question[:answer4]].shuffle!
        answer = prompt.enum_select(question[:question], questions_random)
        current_question += 1
        if answer == question[:correct]
            score += 1
            puts "CORRECT!"
        else
            puts "Wrong. The correct answer was #{question[:correct]}"
        end
        if current_question == current_quiz.length
            puts "Quiz finished! You scored #{score} out of #{current_quiz.length}."
            puts "Press enter to exit"
            gets
            highscores.push({ name: name, score: score })
            File.write("#{quiz.slice(0..-10)}results.json", JSON.pretty_generate(highscores))
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

# def score_adder(players, class_room)
#     puts "Please enter the player in 3rd"
#     third = gets.chomp
#     puts "Please enter the player in 2nd"
#     second = gets.chomp
#     puts "Please enter todays winner"
#     first = gets.chomp
#     first_played = false
#     players.each do |person|
#         first_played = true if person[:name] == first
#     end
#     if first_played == true
#         players.each do |person|
#         if person[:name] = first
#             person[:first] = person[:first].to_i + 1
#         end
#     end
#     else
#         players.push({ name: first, first: 1 })
#     end
#     second_played = false
#     players.each do |person|
#         second_played = true if person[:name] == second
#     end
#     if second_played == true
#         players.each do |person|
#         person[:second] +=1 if person[:name] = second
#         end
#     else
#         players.push({ name: second, second: 1 })
#     end
#     third_played = false
#     players.each do |person|
#         third_played = true if person[:name] == third
#     end
#     if third_played == true
#         players.each do |person|
#         person[:third] +=1 if person[:name] = third
#         end
#     else
#         players.push({ name: third, third: 1 })
#     end
# end
