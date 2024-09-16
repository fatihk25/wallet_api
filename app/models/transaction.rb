class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  validates :amount, numericality: { greater_than: 0 }

  after_create :process_transaction

  private

  def process_transaction
    if source_wallet
      source_wallet.withdraw(amount)
    end

    if target_wallet
      target_wallet.deposit(amount)
    end
  end
end
