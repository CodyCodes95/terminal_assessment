require './classes'

describe '#getter' do
    it "returns the file linked" do
        expect(JSON.parse(JsonGetter.get('/class_test.json'))).to eq []
    end
end