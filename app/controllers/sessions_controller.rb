class SessionsController < ApplicationController
  def create
    entity = find_entity_by_email(params[:email])

    if entity&.authenticate(params[:password])
      session = entity.sessions.create
      render json: { token: session.token, entity_id: entity.id, entity_type: entity.type }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    session = Session.find_by(token: params[:token])
    if session
      session.destroy
      render json: { message: "Logged out successfully" }, status: :ok
    else
      render json: { error: "Invalid token" }, status: :not_found
    end
  end

  private

  def find_entity_by_email(email)
    User.find_by(email: email) || Team.find_by(email: email)
  end
end
