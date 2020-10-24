# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CtfSetting, type: :model do
  before(:each) do
    @ctf_setting = CtfSetting.create(key: 'some key', value: 'some value', value_type: 'String')
  end

  context 'when creating a ctfsetting' do
    it 'is valid with valid attributes' do
      expect(@ctf_setting).to eq(CtfSetting.last)
    end

    it 'enforces uniqueness of a ctf_settings key' do
      expect(CtfSetting.new(key: 'some key', value: 'some value').valid?).to be false
    end
  end
end
