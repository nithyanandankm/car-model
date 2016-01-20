class Model < ActiveRecord::Base
  belongs_to :organization
  has_many :model_types

  def model_types_json
    model_type_json = model_types.map { |model_type| model_type.as_json }
    {
      models: [
        {
          name: name,
          model_types: model_type_json
        }
      ]
    }
  end
end
