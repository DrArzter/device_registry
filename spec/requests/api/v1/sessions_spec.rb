require 'rails_helper'

RSpec.describe 'Api::V1::Sessions', type: :request do
  let!(:user) { create(:user, password: 'password', password_confirmation: 'password') }

  let(:valid_credentials) do
    {
      email: user.email,
      password: 'password'
    }
  end

  let(:invalid_credentials) do
    {
      email: user.email,
      password: 'invalid'
    }
  end

  describe 'POST /api/v1/login' do
    context 'with valid credentials' do
      it 'returns a token and status 200 (ok)' do
        post '/api/v1/login', params: valid_credentials, as: :json
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['token']).not_to be_nil
        expect(ApiKey.find_by(token: json_response['token'])).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns status 401 (unauthorized)' do
        post '/api/v1/login', params: invalid_credentials, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
