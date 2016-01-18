class Model < ActiveRecord::Base
  belongs_to :organization
  has_many :model_types
end
