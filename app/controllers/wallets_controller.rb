class WalletsController < ApplicationController
  before_action :set_wallet, only: [ :show, :deposit, :withdraw ]

  def show
    render json: { balance: @wallet.balance }, status: :ok
  end

  def deposit
    amount = params[:amount].to_f

    if amount <= 0
      render json: { error: "Deposit amount must be greater than zero" }, status: :unprocessable_entity
    else
      @wallet.balance += amount
      if @wallet.save
        render json: { message: "Deposit successful", new_balance: @wallet.balance }, status: :ok
      else
        render json: { error: @wallet.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def withdraw
    amount = params[:amount].to_f

    if amount <= 0
      render json: { error: "Withdrawal amount must be greater than zero" }, status: :unprocessable_entity
    elsif @wallet.balance < amount
      render json: { error: "Insufficient funds" }, status: :unprocessable_entity
    else
      @wallet.balance -= amount
      if @wallet.save
        render json: { message: "Withdrawal successful", new_balance: @wallet.balance }, status: :ok
      else
        render json: { error: @wallet.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def set_wallet
    @wallet = Wallet.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Wallet not found" }, status: :not_found
  end
end
