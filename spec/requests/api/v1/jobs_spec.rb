require 'rails_helper'

RSpec.describe 'Api::V1::Jobs', type: :request do
  before do
    @user = User.create(name: 'User1', email: 'email1@example.com', phone: '+618123456789')
    @job = Job.create(title: 'Job1', description: 'JobDescription1', status: 'pending', user_id: @user.id)
  end

  let(:response_json) { JSON.parse(response.body) }
  let(:user) { @user.as_json }

  describe 'GET /api/v1/jobs' do
    it 'returns a status message' do
      get api_v1_jobs_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of jobs' do
      get api_v1_jobs_path
      first = response_json.first
      expect(first['title']).to eql(@job.title)
      expect(first['description']).to eql(@job.description)
      expect(first['status']).to eql(@job.status)
      expect(first['user']).to eq(user)
    end
  end

  describe 'GET /api/v1/jobs/:id' do
    it 'returns a 200 status message if data exists' do
      get api_v1_job_path(id: @job.id)
      expect(response).to have_http_status(:ok)
    end

    it 'returns a job if data exists' do
      get api_v1_job_path(id: @job.id)
      expect(response_json['title']).to eql(@job.title)
      expect(response_json['description']).to eql(@job.description)
      expect(response_json['status']).to eql(@job.status)
      expect(response_json['user']).to eql(user)
    end

    it 'returns a 404 status message if data is not found' do
      get api_v1_job_path(id: 0)
      expect(response).to have_http_status(:not_found)
      expect(response_json['error']).to eql('Record not found')
    end
  end

  describe 'POST /api/v1/jobs' do
    it 'returns 201 when valid job has been created' do
      title = 'Job2'
      description = 'JobDescription2'
      status = 'pending'

      post '/api/v1/jobs', params: {
        job: {
          title: title,
          description: description,
          status: status,
          user_id: @user.id
        }
      }
  
      expect(response).to have_http_status(:created)
      expect(response_json['title']).to eql(title)
      expect(response_json['description']).to eql(description)
      expect(response_json['status']).to eql(status)
    end

    it 'returns 422 when input is invalid' do
      post '/api/v1/jobs', params: {
        job: {
          title: '',
          description: '',
          status: '',
          user: nil,
        }
      }
  
      expect(response).to have_http_status(:unprocessable_content)
      expect(response_json['errors']).to contain_exactly(
        "Title can't be blank",
        "Description can't be blank",
        "Status can't be blank",
        "Status is not included in the list",
        "User must exist"
      )
    end
  end

  describe 'PUT /api/v1/jobs/:id' do
    it 'returns 200 when job has been updated' do
      title = 'Job3'

      put "/api/v1/jobs/#{@job.id}", params: {
        job: {
          title: title,
        }
      }
  
      expect(response).to have_http_status(:ok)
      expect(response_json['title']).to eql(title)
    end

    it 'returns 422 when input is invalid' do
      put "/api/v1/jobs/#{@job.id}", params: {
        job: {
          title: '',
          description: '',
          status: '',
          user_id: nil,
        }
      }
  
      expect(response).to have_http_status(:unprocessable_content)
      expect(response_json['errors']).to contain_exactly(
        "Title can't be blank",
        "Description can't be blank",
        "Status can't be blank",
        "Status is not included in the list",
        "User must exist"
      )
    end
  end

  describe 'DELETE /api/v1/jobs/:id' do
    it 'returns nothing' do
      delete "/api/v1/jobs/#{@job.id}"
  
      expect(response).to have_http_status(:no_content)
    end
  end
end
