require 'rails_helper'

describe Api::V1::ModelsController, type: :controller do
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
        post 'model_types_price', model_id: @model.model_slug, model_type_id: @model_type.model_type_slug
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
      context 'when base_price is not passed' do
        before :each do
          @model_type.destroy
          post 'model_types_price', model_id: @model.model_slug, api_key: @access_token, model_type_id: @model_type.model_type_slug
          @json_response = JSON.parse(response.body)
        end

        it 'returns response code 422 in response body' do
          expect(response.code).to eq '422'
        end

        it 'returns status code 422 in response body' do
          expect(@json_response['code']).to eq 422
        end

        it 'returns appropriate error message in response body' do
          expect(@json_response['error']).to eq "Missing parameter 'base_price'"
        end
      end

      context 'when model_type is not found' do
        before :each do
          @model_type.destroy
          post 'model_types_price', model_id: @model.model_slug, api_key: @access_token, model_type_id: 'invalid-slug',
            base_price: 20000
          @json_response = JSON.parse(response.body)
        end

        it 'returns response code 404 in response body' do
          expect(response.code).to eq '404'
        end

        it 'returns status code 404 in response body' do
          expect(@json_response['code']).to eq 404
        end

        it 'returns appropriate error message in response body' do
          expect(@json_response['error']).to eq "Couldn't find model_type for 'invalid-slug'"
        end
      end

      context 'when model_types exists' do
        before :each do
          post 'model_types_price', model_id: @model.model_slug, api_key: @access_token,
            model_type_id: @model_type.model_type_slug, base_price: 20000
          @json_response = JSON.parse(response.body)
        end

        it 'returns response code 200 in response body' do
          expect(response.code).to eq '200'
        end

        it 'should not return error block' do
          expect(@json_response['error']).to be_nil
        end

        it 'results should have model_type name' do
          expect(@json_response['model_type']['name']).to eq 'E 101'
        end

        it 'results should return the base_price from request params' do
          expect(@json_response['model_type']['base_price']).to eq '20000'
        end

        it 'results should respond with calculated actual price' do
          expect(@json_response['model_type']['total_price']).not_to be_nil
        end
      end
    end
  end
end