RSpec.describe Api::V1::PerformanceDataController, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }

  describe 'POST /api/v1/performance_data' do
    it 'creates a data entry' do
      post '/api/v1/performance_data', params: {
        performance_data: { data: { message: 'Average' } }
      }, headers: headers

      entry = PerformanceData.last
      expect(entry.data).to eq 'message' => 'Average'
    end
  end

  describe 'GET /api/v1/performance_data' do
    before do
      5.times { user.performance_data.create(data: { message: 'Average'}) }
    end

    it 'returns a collection of performance data' do
      get '/api/v1/performance_data', headers: headers
      expect(response_json['entries'].count).to eq 5
    end

    it 'returns a collection of performance data for the correct user' do
      get '/api/v1/performance_data', headers: headers
      user.performance_data.each do |performance_data|
        expect(performance_data.data['message']).to eq 'Average'
      end
    end
  end
end
