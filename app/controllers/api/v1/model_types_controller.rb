module Api
  module V1
    class ModelTypesController < BaseApiController
      def index
        handle_exception do
          model = Model.find_by_model_slug(params[:model_id])
          render json: model.model_types_json, callback: params[:callback]
        end
      end
    end
  end
end
