require 'rails_helper'

describe Friendship do
  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :friend }
  end

  describe 'validations' do
    it { should define_enum_for(:status).with_values([:pending, :approved]) }
  end
end
