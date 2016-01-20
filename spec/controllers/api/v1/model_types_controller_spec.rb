require 'rails_helper'

describe Api::V1::ModelTypesController, type: :controller do
  before :each do
    @user = FactoryGirl.create(:user)
    @org = FactoryGirl.create(:organization, user_id: @user.id)
    @model = FactoryGirl.create(:model, organization_id: @org.id)
    @model_type = FactoryGirl.create(:model_type, model_id: @model.id)
    api_key = FactoryGirl.create(:api_key, user_id: @user.id, access_token: 'f5a1ff6d-1fee-47ca-847c-4095fd3b0117')
    @access_token = api_key.access_token
  end

  describe '#index' do
    describe 'When access token is not valid' do
      before :each do
        get 'index', model_id: @model.model_slug
        @json_response = JSON.parse(response.body)
      end

      it 'returns response code 401 in response body' do
        expect(response.code).to eq '401'
      end

      it 'returns status code 401 in response body' do
        expect(@json_response['code']).to eq 401
      end

      it 'returns appropriate error message in response body' do
        expect(@json_response['error']).to eq 'HTTP Token: Access denied.'
      end
    end


    describe 'When access token is valid' do
      context 'when there are no model_types for the given model slug' do
        before :each do
          @model_type.destroy
          get 'index', model_id: @model.model_slug, api_key: @access_token
          @json_response = JSON.parse(response.body)
        end

        it 'should first model with name as \'Audi E Class\'' do
          expect(@json_response['models'][0]['name']).to eq 'Audi E Class'
        end

        it 'should return an empty array for model_types' do
          expect(@json_response['models'][0]['model_types']).to match_array []
        end
      end

      context 'when model_types exists' do
        before :each do
          get 'index', model_id: @model.model_slug, api_key: @access_token
          @json_response = JSON.parse(response.body)
        end

        it 'returns response code 200 in response body' do
          expect(response.code).to eq '200'
        end

        it 'results should have only one model instance' do
          expect(@json_response['models'].size).to eq 1
        end

        it 'should first model with name as \'Audi E Class\'' do
          expect(@json_response['models'][0]['name']).to eq 'Audi E Class'
        end

        it 'should return models as an array' do
          expect(@json_response['models'].class.name).to eq 'Array'
        end
      end
    end
  end
end