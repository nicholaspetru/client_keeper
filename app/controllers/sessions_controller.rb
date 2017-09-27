class SessionsController < ApplicationController
  def new
  end

  def create
    @store = Store.find_by(username: params[:session][:username])
    if @store && @store.authenticate(params[:session][:password])
      flash[:success] = 'Welcome back!'
      login(@store)
      redirect_to clients_path
    else
      flash[:danger] = 'Invalid username and/or password'
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
