require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { User.create(name: 'User1', email: 'email1@example.com', phone: '+618123456789') }
  subject { described_class.new(user).serializable_hash }

  describe '.serializable_hash' do
    it 'includes user properties' do
      expect(subject).to include(:id, :name, :email, :phone, :created_at, :updated_at)
    end

    it 'returns correct keys and values' do
      expect(subject[:id]).to eql(user.id)
      expect(subject[:name]).to eql(user.name)
      expect(subject[:email]).to eql(user.email)
      expect(subject[:phone]).to eql(user.phone)
      expect(subject[:created_at]).to eql(user.created_at)
      expect(subject[:updated_at]).to eql(user.updated_at)
    end
  end
end
