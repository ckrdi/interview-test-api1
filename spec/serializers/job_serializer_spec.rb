require 'rails_helper'

RSpec.describe JobSerializer, type: :serializer do
  let(:user) { User.create(name: 'User1', email: 'email1@example.com', phone: '+618123456789') }
  let(:job) { Job.create(title: 'Job1', description: 'JobDescription1', status: 'pending', user_id: user.id) }
  subject { described_class.new(job).serializable_hash }

  describe '.serializable_hash' do
    it 'includes job properties' do
      expect(subject).to include(:id, :title, :description, :status, :user_id, :created_at, :updated_at)
    end

    it 'returns correct keys and values' do
      expect(subject[:id]).to eql(job.id)
      expect(subject[:title]).to eql(job.title)
      expect(subject[:description]).to eql(job.description)
      expect(subject[:status]).to eql(job.status)
      expect(subject[:created_at]).to eql(job.created_at)
      expect(subject[:updated_at]).to eql(job.updated_at)
      expect(subject[:user_id]).to eql(job.user_id)
    end
  end
end
