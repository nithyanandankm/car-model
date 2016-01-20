module Api
  class BaseApiController < ApplicationController
    before_action :restrict_access_by_token
    skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }

    protected

    def restrict_access_by_token
      handle_exception do
        org = organization_from_request_param
        api_key = ApiKey.exists?(access_token: params[:api_key], user_id: org.user_id)

        unless api_key
          authenticate_or_request_with_http_token do |token, _options|
            ApiKey.exists?(access_token: token, user_id: org.user_id)
          end
        end
      end
    end

    def handle_exception
      yield
    rescue ActiveRecord::RecordNotFound => ex0
      render json: { error: ex0.message, code: 404 }, status: 404, callback: params[:callback]
      return
    rescue ArgumentError => ex1
      render json: { error: ex1.message, code: 422 }, status: 422, callback: params[:callback]
      return
    rescue => ex2
      render json: { error: ex2.message, code: 500 }, status: 500, callback: params[:callback]
      return
    end

    private

    def organization_from_request_param
      # TODO : Ideally all requests should be scoped under organization_id
      # eg: /api/v1/organizations/:organization_id/models/:model_id/model_types
      return Organization.find(params[:organization_id]) if params[:organization_id]
      if params[:model_id]
        model = Model.find_by_model_slug(params[:model_id])
        fail "Couldn't find Model for 'params[:model_id]'" if model.blank?
        model.organization
      end
    end

    def request_http_token_authentication(realm = "Application")
      self.headers['WWW-Authenticate'] = %(Token realm="#{realm.gsub(/"/, '')}")
      render json: { error: 'HTTP Token: Access denied.', code: 401 }, status: :unauthorized
    end
  end
end
