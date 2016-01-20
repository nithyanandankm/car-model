class ModelType < ActiveRecord::Base
  belongs_to :model

  def as_json
    {
      name: name,
      total_prize: base_price
    }
  end

  def model_types_price_json(give_base_price)
    {
      model_type: {
        name: name,
        base_price: give_base_price,
        total_price: base_price
      }
    }
  end
end
