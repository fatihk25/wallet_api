class Session < ApplicationRecord
  belongs_to :entity, polymorphic: true

  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  private

  def generate_token
    self.token = SecureRandom.hex(20) unless self.token.present?
  end
end
