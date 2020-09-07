# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'valid with user name' do
      expect(User.new(name: 'Test User')).to be_valid
    end

    it 'in valid with user name' do
      expect(User.new).not_to be_valid
    end
  end
end
