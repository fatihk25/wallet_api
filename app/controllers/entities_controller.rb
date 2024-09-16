class EntitiesController < ApplicationController
  before_action :set_entity, only: [ :show, :update, :destroy ]

  def index
    @entities = Entity.all
    render json: @entities
  end

  def show
    render json: @entity
  end

  def create
    @entity = if params[:type] == "User"
      User.new(entity_params)
    else
      Team.new(entity_params)
    end

    if @entity.save
      render json: @entity, status: :created
    else
      render json: @entity.errors, status: :unprocessable_entity
    end
  end

  def update
    if @entity.update(entity_params)
      render json: @entity
    else
      render json: @entity.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @entity.destroy
    head :no_content
  end

  private

  def set_entity
    @entity = Entity.find(params[:id])
  end

  def entity_params
    params.require(:entity).permit(:name, :email, :password)
  end
end
