require 'rails_helper'

RSpec.describe User, type: :model do
  before { described_class.create(name: 'User1', email: 'email1@example.com', phone: '+618123456789') }
  subject { described_class.new(name: 'User2', email: 'email2@example.com', phone: '+628123456789') }

  describe 'validations' do
    describe 'name' do
      it 'must be present' do    
        subject.name = nil
        expect(subject).to_not be_valid
      end
    end

    describe 'email' do
      it 'must be present' do
        subject.email = nil
        expect(subject).to_not be_valid
      end

      it 'must be valid email' do
        subject.email = 'email123'
        expect(subject).to_not be_valid
      end

      it 'must be unique email' do
        subject.email = 'email1@example.com'
        expect(subject).to_not be_valid
      end
    end

    describe 'phone' do
      it 'must be present' do
        subject.phone = nil
        expect(subject).to_not be_valid
      end
    end

    it 'properties must be present and valid' do
      expect(subject).to be_valid
    end
  end
end
