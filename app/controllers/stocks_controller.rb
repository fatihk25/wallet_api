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

  def search
     if params[:api_key].blank? || (params[:identifier].blank? && params[:identifiers].blank?)
      render json: { error: "API key and at least one identifier are required" }, status: :bad_request
      return
     end

    stock_service = LatestStockPrice::StockService.new(params[:api_key])

    if params[:identifier]
      result = stock_service.price(params[:identifier])
    elsif params[:identifiers]
      identifiers = params[:identifiers].split(",")
      result = stock_service.prices(identifiers)
    else
      render json: { error: "Please provide an identifier or identifiers for searching" }, status: :bad_request
      return
    end

    if result.present?
      render json: result
    else
      render json: { message: "No stocks found" }, status: :not_found
    end
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
