module Api
  module V1
    class ModelsController < BaseApiController
      def model_types_price
        handle_exception do
          raise ArgumentError.new("Missing parameter 'base_price'") if params[:base_price].blank?

          model = Model.find_by_model_slug(params[:model_id])
          model_type = model.model_types.find_by_model_type_slug(params[:model_type_id])
          raise ActiveRecord::RecordNotFound.new("Couldn't find model_type for '#{params[:model_type_id]}'") if model_type.blank?

          render json: model_type.model_types_price_json(params[:base_price]), callback: params[:callback]
        end
      end
    end
  end
end
