**Provide a link to your source control repository**

https://github.com/CodyCodes95/terminal_assessment

**Identify any code style guide or styling conventions that the application will adhere to.**

**Reference the chosen style guide appropriately.**

My application will adhere to The Ruby Style Guide, found here: [Ruby Style Guide](https://rubystyle.guide/)

**Develop a list of features that will be included in the application. It must include:**
- at least THREE features
- describe each feature

**Note: Ensure that your features above allow you to demonstrate your understanding of the following language elements and concepts:**
- use of variables and the concept of variable scope
- loops and conditional control structures
- error handling

**Feateure One - Quiz Maker**

My application's first feature will be the quiz maker. Once the user has selected that they wish to make a quiz, they are prompted to give the quiz a name so that the quiz can be referenced later. After that the input the amount of questions they want the quiz to have, then all that is left to do is enter each question, along with four answers, one real answer and three wrong answers. Once all questions and answers have been entered, the application creates a new JSON file with all the data necessary to be able to play the quiz. Which leads into the next feature -

**Feature Two - Quiz Player**

Once selected, the quiz player will ask the user which quiz they would like to play. It will list out all quiz.json files in the current directory and ask the user to select one. Once selected, the program will output each question followed by the four potential answers. The player then inputs a number between 1 and 4 to select their answer. If the answer is correct, they recieve one point and move onto the next question. If they incorrectly answer the question, they are not awarded a point and move onto the next question. Once the final question has been answered, the program displays the score they achieved out of the total possible score for that quiz. Their name along with score achieved is then written to the highscore file for that quiz, and players can then compare their score to other players'. This neatly ties into the next feature...

**Feature Three - Highscores and Leaderboards**

Highscores and leaderboards are a way to view the highest scores for a particular quiz inside of the app. Each time a quiz is taken, a new entry is written to that particular quiz' results file. This stores the name of the player, and the score they achieved, and can be viewed by selecting which quiz you want to view scores for. The results files can be modified through the admin menu of the app. This is accessed by typing in -admin as an argument when running the app, then entering the password. This allows admins to update scores manually for a variety of reasons, maybe a player was found cheating and needed their score removed, for example.

**Develop an implementation plan which:**
- outlines how each feature will be implemented and a checklist of tasks for each feature
- prioritise the implementation of different features, or checklist items within a feature
- provide a deadline, duration or other time indicator for each feature or checklist/checklist-item

**Utilise a suitable project management platform to track this implementation plan.**

**Provide screenshots/images and/or a reference to an accessible project management platform used to track this implementation plan. **

