require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:user) { User.create(name: 'User1', email: 'email1@example.com', phone: '+618123456789') }
  subject { described_class.new(title: 'Job1', description: 'JobDescription1', status: 'pending', user_id: user.id) }

  describe 'title' do
    it 'must be present' do    
      subject.title = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'description' do
    it 'must be present' do    
      subject.description = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'status' do
    it 'must be present' do    
      subject.status = nil
      expect(subject).to_not be_valid
    end

    it 'must be included in the list' do
      subject.status = 'success'
      expect(subject).to_not be_valid
    end
  end

  describe 'relation' do
    it 'must belong to a user' do
      subject.user = nil
      expect(subject).to_not be_valid
    end
  end
end
