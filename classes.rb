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
    def get_hash
        self.class.get('/scoreboard_hash.json')
    end
end