class TransactionsController < ApplicationController
  def create
    source_wallet = Wallet.find_by(id: params[:source_wallet_id])
    target_wallet = Wallet.find_by(id: params[:target_wallet_id])
    amount = params[:amount].to_f

    if source_wallet.nil? || target_wallet.nil?
      render json: { error: "Source or target wallet not found" }, status: :not_found
      return
    end

    if amount <= 0
      render json: { error: "Transfer amount must be greater than zero" }, status: :unprocessable_entity
      return
    end

    if source_wallet.balance < amount
      render json: { error: "Insufficient funds in source wallet" }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      source_wallet.update!(balance: source_wallet.balance - amount)
      target_wallet.update!(balance: target_wallet.balance + amount)
    end

    render json: { message: "Transfer successful", source_wallet_balance: source_wallet.balance, target_wallet_balance: target_wallet.balance }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: "Transaction failed: #{e.message}" }, status: :unprocessable_entity
  end
end
