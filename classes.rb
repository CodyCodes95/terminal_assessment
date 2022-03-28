class JsonGetter
    include HTTParty
    base_uri "raw.githubusercontent.com/CodyCodes95/kahoot_kompanion/master/"
    def get
        self.class.get('/scoreboard.json')
    end
end