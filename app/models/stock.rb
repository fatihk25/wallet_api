class Stock < ApplicationRecord
  has_one :wallet, as: :walletable, dependent: :destroy

  validates :name, :symbol, presence: true
  validates :symbol, uniqueness: true

  after_create :create_wallet

  private

  def create_wallet
    Wallet.create(walletable: self)
  end
end
