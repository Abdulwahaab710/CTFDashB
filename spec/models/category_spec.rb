require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'When creating a new category' do
    before(:each) do
      @category = Category.create!(name: 'Web 101')
    end

    it 'is valid with valid attributes' do
      expect(@category).to eq(Category.first)
    end

    it 'enforces uniqueness of Category name' do
      expect(Category.new(name: 'Web 101').valid?).to be false
    end
  end
end
