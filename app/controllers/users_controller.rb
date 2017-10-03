class UsersController < ApplicationController
  before_action :set_local_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.get_request("users/" + @local_user.token).parsed_response
  end

  def new
    @user = User.new
  end

  def create
    body = get_user_body
    response = User.post_request("users/", body)

    unless response['error_code'].nil?
      flash[:danger] = response['error_message']
      redirect_to new_user_path
    else
      flash[:success] = "New user successfully created (in API). "
      user = User.create(
        first_name: response['first_name'],
        last_name: response['last_name'],
        email: response['email'],
        token: response['token']
      )
      respond_to do |format|
        if user.save
          flash[:success] = "New user successfully created (locally)!"
          format.html { redirect_to user }
          format.json { render :show, status: :created, location: user }
        else
          format.html { render :new }
          format.json { render json: user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def edit
    @user = User.get_request("users/#{@local_user.token}").parsed_response
  end

  def update
    body = get_user_body
    response = User.put_request("users/#{@local_user.token}", body)

    unless response['error_code'].nil?
      flash[:danger] = response['error_message']
      redirect_to edit_user_path(local_store)
    else
      flash[:success] = "User API successfully udpated."
      user = User.update(params[:id], {
        first_name: response['first_name'],
        last_name: response['last_name'],
        email: response['email'],
        token: response['token']
      })

      respond_to do |format|
        if user
          flash[:success] = "Local user successfully updated!"
          format.html { redirect_to user_path(user) }
          format.json { render :show, status: :created, location: user }
        else
          flash[:danger] = response['error_message']
          format.html { render :new }
          format.json { render json: user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to clients_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_user_body
    { :first_name => params['user']['first_name'],
      :last_name => params['user']['last_name'],
      :email => params['user']['email'],
      :address1 => params['user']['address1'],
      :city => params['user']['city'],
      :state => params['user']['state'],
      :zip => params['user']['zip']
    }.to_json
  end

  private
    def set_local_user
      @local_user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :token)
    end
end
