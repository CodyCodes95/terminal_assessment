require './methods'

describe "#quiz_getter" do
    it "should return an array of all JSON files with the suffix _quiz" do
        expect(quiz_getter).to eq ["test_quiz.json"]
    end
end

describe "#results_getter" do
    it "should return an array of all JSON files with the suffix _results" do
        expect(results_getter).to eq []
    end
end