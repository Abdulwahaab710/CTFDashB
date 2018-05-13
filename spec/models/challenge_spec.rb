require 'rails_helper'

RSpec.describe Challenge, type: :model do
  before(:each) do
    @category = Category.create(name: 'web 101')
    @challenge = Challenge.create(
      title: 'sqli baby',
      points: 100,
      max_tries: 99,
      link: 'https://somedomain.com/path',
      description: 'Finish the challenge to get the flag',
      active: false,
      flag: 'flag{hello world}',
      category: @category
    )
  end

  context 'when create a challenge' do
    it 'is valid with valid attributes' do
      expect(@challenge).to eq(Challenge.first)
    end

    it 'belongs to a category' do
      expect(@category).to eq(Challenge.last.category)
    end

    # it 'enforces uniqueness of Challenge title' do
    #   expect(
    #     Challenge.create(
    #       title: 'sqli baby',
    #       points: 100,
    #       max_tries: 99,
    #       link: 'https://somedomain.com/path',
    #       description: 'Finish the challenge to get the flag',
    #       active: false,
    #       flag: 'flag{hello world}',
    #       category: @category
    #     ).valid?
    #   ).to be false
    # end
  end
end
