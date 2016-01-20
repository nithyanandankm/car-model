class User < ActiveRecord::Base
  has_many :api_keys
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def api_creds
    return api_keys.first if api_keys.present?

    new_api_key = api_keys.build
    new_api_key.name = 'Default Key'
    new_api_key.save!
  end
end
