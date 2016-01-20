class ModelType < ActiveRecord::Base
  belongs_to :model

  def as_json
    {
      name: name,
      total_prize: total_price(base_price)
    }
  end

  def model_types_price_json(given_base_price)
    {
      model_type: {
        name: name,
        base_price: given_base_price,
        total_price: total_price(given_base_price)
      }
    }
  end

  def total_price(given_base_price)
    pricing_policy = model && model.organization && model.organization.pricing_policy
    policy = PricingPolicy.new(pricing_policy, given_base_price)
    policy.total_price
  rescue => exc
    Rails.logger.error exc.message
    Rails.logger.error exc.backtrace
    nil
  end
end
