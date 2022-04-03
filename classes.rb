require 'httparty'

class JsonGetter
    include HTTParty
    base_uri "raw.githubusercontent.com/CodyCodes95/terminal_assessment/master/"
    def get_test
        self.class.get('/class_test.json')
    end
    def get
        self.class.get('/accelerated.json')
    end
end

class AlreadyPlayedError < StandardError
    def message
        return "You have already played this quiz! Please enter a different name"
    end
end