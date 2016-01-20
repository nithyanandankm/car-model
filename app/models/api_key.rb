class ApiKey < ActiveRecord::Base
  belongs_to :user

  before_create :generate_access_token

  private

  def generate_access_token
    loop do
      begin
        self.access_token = SecureRandom.hex
      end
      break unless self.class.exists?(access_token: access_token)
    end
  end
end