require './classes'

describe "jsongetter" do 
     subject(:classroom) {JsonGetter.new}
    it 'can be instantiated' do
        expect(classroom).not_to be_nil
        expect(classroom).to be_an_instance_of JsonGetter
    end
end

describe '#getter' do
    subject(:classroom) {JsonGetter.new}
    it "returns the file linked" do
        expect(JSON.parse(classroom.get_test)).to eq []
    end
end