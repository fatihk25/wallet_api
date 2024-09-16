class Entity < ApplicationRecord
  has_secure_password

  has_one :wallet, as: :walletable, dependent: :destroy
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 6 }

  after_create :create_wallet

  private

  def create_wallet
    Wallet.create(walletable: self)
  end
end
