# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScoresController, type: :controller do
  context 'GET :index' do
    it 'returns a success' do
      get :index
      expect(response).to be_successful
    end
  end
end
