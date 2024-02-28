class UsersController < ApplicationController
  def list
    @users = User.order(:id).page(params[:page]).per(5)
  end
end
