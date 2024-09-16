class StocksController < ApplicationController
  before_action :set_stock, only: [ :show, :update, :destroy ]

  def index
    @stocks = Stock.all
    render json: @stocks
  end

  def show
    render json: @stock
  end

  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      render json: @stock, status: :created
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  def update
    if @stock.update(stock_params)
      render json: @stock
    else
      render json: @stock.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
    render json: { message: "Delete successful" }
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Stock not found" }, status: :not_found
  end

  def stock_params
    params.require(:stock).permit(:name, :symbol)
  end
end
