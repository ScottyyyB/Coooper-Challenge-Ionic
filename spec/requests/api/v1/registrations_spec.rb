RSpec.describe 'User Registration', type: :request do
  let(:headers) { { HTTP_ACCEPT: 'application/json'} }

  context 'with valid credentials' do
    it 'returns a user and token' do
      post '/api/v1/auth', params: {
        email: 'example@craftacademy.se', password: 'password',
        password_confirmation: 'password'
      }, headers: headers

      expect(response_json['status']).to eq 'success'
      expect(response.status).to eq 200
    end
  end

  context 'returns an error message when user submits' do
    it 'non-matching password confirmation' do
      post '/api/v1/auth', params: {
        email: 'example@craftacademy.se', password: 'password',
        password_confirmation: 'wrong_password'
      }, headers: headers

      expect(response_json['errors']['password_confirmation'])
        .to eq ["doesn't match Password"]
      expect(response.status).to eq 422
    end

    it 'an invalid email address' do
      post '/api/v1/auth', params: {
        email: 'example@craft', password: 'password',
        password_confirmation: 'password'
      }, headers: headers

      expect(response_json['errors']['email']).to eq ['is not an email']
      expect(response.status).to eq 422
    end

    it 'an already registered email' do
      FactoryBot.create(:user, email: 'example@craftacademy.se',
                               password: 'password',
                               password_confirmation: 'password')
      post '/api/v1/auth', params: {
        email: 'example@craftacademy.se', password: 'password',
        password_confirmation: 'password'
      }, headers: headers

      expect(response_json['errors']['email']).to eq ['has already been taken']
      expect(response.status).to eq 422
    end

    it 'no password is given' do
      post '/api/v1/auth', params: {
        email: 'example@craftacademy.se'
      }, headers: headers

      expect(response_json['errors']['password']).to eq ["can't be blank"]
      expect(response.status).to eq 422
    end

    it 'an invalid password' do
      post '/api/v1/auth', params: {
        email: 'example@craftacademy.se', password: 'hi',
        password_confirmation: 'hi'
      }, headers: headers

      expect(response_json['errors']['password']).to eq ['is too short (minimum is 8 characters)']
      expect(response.status).to eq 422
    end
  end
end
