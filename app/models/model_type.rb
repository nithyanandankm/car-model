class ModelType < ActiveRecord::Base
  belongs_to :model

  def as_json
    {
      name: name,
      total_prize: base_price
    }
  end
end
