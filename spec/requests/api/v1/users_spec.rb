require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  before { @user = User.create(name: 'User1', email: 'email1@example.com', phone: '+618123456789') }
  let(:response_json) { JSON.parse(response.body) }

  describe 'GET /api/v1/users' do
    it 'returns a status message' do
      get api_v1_users_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of users' do
      get api_v1_users_path
      first = response_json.first
      expect(first['name']).to eql(@user.name)
      expect(first['email']).to eql(@user.email)
      expect(first['phone']).to eql(@user.phone)
    end
  end

  describe 'GET /api/v1/user/:id' do
    it 'returns a 200 status message if data exists' do
      get api_v1_user_path(id: @user.id)
      expect(response).to have_http_status(:ok)
    end

    it 'returns a user if data exists' do
      get api_v1_user_path(id: @user.id)
      expect(response_json['name']).to eql(@user.name)
      expect(response_json['email']).to eql(@user.email)
      expect(response_json['phone']).to eql(@user.phone)
    end

    it 'returns a 404 status message if data is not found' do
      get api_v1_user_path(id: 0)
      expect(response).to have_http_status(:not_found)
      expect(response_json['error']).to eql('Record not found')
    end
  end

  describe 'POST /api/v1/users' do
    it 'returns 201 when valid user has been created' do
      name = 'User2'
      email = 'email2@example.com'
      phone = '+628123456789'

      post '/api/v1/users', params: {
        user: {
          name: name,
          email: email,
          phone: phone
        }
      }

      expect(response).to have_http_status(:created)
      expect(response_json['name']).to eql(name)
      expect(response_json['email']).to eql(email)
      expect(response_json['phone']).to eql(phone)
    end

    it 'returns 422 when input is invalid' do
      post '/api/v1/users', params: {
        user: {
          name: '',
          email: '',
          phone: ''
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response_json['errors']).to contain_exactly(
        "Name can't be blank",
        "Email can't be blank",
        "Email is invalid",
        "Phone can't be blank"
      )
    end
  end

  describe 'PUT /api/v1/users/:id' do
    it 'returns 200 when user has been updated' do
      name = 'User3'

      put "/api/v1/users/#{@user.id}", params: {
        user: {
          name: name
        }
      }

      expect(response).to have_http_status(:ok)
      expect(response_json['name']).to eql(name)
    end

    it 'returns 422 when input is invalid' do
      put "/api/v1/users/#{@user.id}", params: {
        user: {
          name: '',
          email: '',
          phone: ''
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response_json['errors']).to contain_exactly(
        "Name can't be blank",
        "Email can't be blank",
        "Email is invalid",
        "Phone can't be blank"
      )
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    it 'returns nothing' do
      delete "/api/v1/users/#{@user.id}"

      expect(response).to have_http_status(:no_content)
    end
  end
end
