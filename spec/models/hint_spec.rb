require 'rails_helper'

RSpec.describe Hint, type: :model do
  context 'when creating a hint' do
    let(:challenge) { FactoryBot.create(:challenge) }

    it 'is valid with valid attributes' do
      expect(Hint.new(challenge: challenge, hint_text: 'this is a hint', penalty: 10)).to be_valid
    end

    it 'is invalid without a challenge' do
      expect(Hint.new(hint_text: 'this is a hint', penalty: 10)).not_to be_valid
    end

    it 'is invalid without a hint_text' do
      expect(Hint.new(challenge: challenge, penalty: 10)).not_to be_valid
    end

     it 'defaults to zero for the penalty' do
      Hint.create(challenge: challenge, hint_text: 'this is a hint')
      expect(Hint.first.penalty).to eq(0)
    end
 end
end
