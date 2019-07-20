# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Challenge, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    @category = FactoryBot.create(:category, name: 'web 101')
    @challenge = Challenge.create(
      title: 'sqli baby',
      points: 100,
      max_tries: 99,
      link: 'https://somedomain.com/path',
      description: '# Finish the challenge to get the flag',
      active: false,
      flag: 'flag{helloworld}',
      category: @category,
      user: @user
    )
    CtfSetting.create(key: 'flag_regex', value: 'flag{[A-Za-z0-9]+}')
  end

  context 'when create a challenge' do
    it 'is valid with valid attributes' do
      expect(@challenge).to eq(Challenge.first)
    end

    it 'belongs to a category' do
      expect(@category).to eq(Challenge.last.category)
    end

    it 'validates flag format before save' do
      expect(
        Challenge.new(
          title: 'XSS baby',
          points: 100,
          max_tries: 99,
          link: 'https://somedomain.com/path',
          description: '# Finish the challenge to get the flag',
          active: false,
          flag: 'flag(hello world)',
          category: @category,
          user: @user
        )
      ).to_not be_valid
    end

    it 'is not valid without a user' do
      expect(
        Challenge.new(
          title: 'XSS baby',
          points: 100,
          max_tries: 99,
          link: 'https://somedomain.com/path',
          description: '# Finish the challenge to get the flag',
          active: false,
          flag: 'flag{flag}',
          category: @category,
          user: nil
        )
      ).to_not be_valid
    end
  end

  context 'when calling to_md' do
    it 'converts markdown to html' do
      expect(@challenge.description.to_md).to eq("<h1>Finish the challenge to get the flag</h1>\n")
    end
  end

  context 'when calling for challenges' do
    let(:challenge_second) { FactoryBot.create(:challenge, title: 'challenge2', flag: 'flag{flag}') }
    let(:challenge_first) { FactoryBot.create(:challenge, title: 'challenge1', flag: 'flag{flag}') }

    it 'returns them sorted by title' do
      expect(Challenge.all).to eq([challenge_first, challenge_second, @challenge])
    end
  end
end
