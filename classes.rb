require 'httparty'

class JsonGetter
    include HTTParty
    base_uri "raw.githubusercontent.com/CodyCodes95/terminal_assessment/master/"
    def get_test
        self.class.get('/class_test.json')
    end
    def get
        self.class.get('/scoreboard.json')
    end
end

class InvalidAnswerError < StandardError
    def message
        return "Answer must be a number between 1 and 4"
    end
end

class AlreadyPlayedError < StandardError
    def message
        return "You have already played this quiz! Please enter a different name"
    end
end