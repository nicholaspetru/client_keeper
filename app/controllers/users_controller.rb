class UsersController < ApplicationController
  before_action :set_local_user, only: [:show, :edit, :update, :destroy]

  @@base_url = "https://shared-sandbox-api.marqeta.com/v3/users/"

  def index
    @users = User.all
  end

  def show
    @user = User.get_request(@@base_url + @local_user.token).parsed_response
  end

  def new
    @user = User.new
  end

  def create
    @body = {
      :first_name => params['user']['first_name'],
      :last_name => params['user']['last_name'],
      :email => params['user']['email'],
      :address1 => params['user']['address1'],
      :city => params['user']['city'],
      :state => params['user']['state'],
      :zip => params['user']['zip']
    }.to_json

    @response = User.post_request(@@base_url, @body)

    @user = User.create(
      first_name: @response['first_name'],
      last_name: @response['last_name'],
      email: @response['email'],
      token: @response['token']
    ) unless @response['token'].nil?

    unless @response['error_code'].nil?
      flash[:danger] = @response['error_message']
    else
      respond_to do |format|
        if @user.save
          flash[:success] = "New user successfully created!"
          format.html { redirect_to @user }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def edit
    @user = retrieve_user_data(@local_user.token)
  end

  def update
    @body = {
      :first_name => params['user']['first_name'],
      :last_name => params['user']['last_name'],
      :email => params['user']['email'],
      :address1 => params['user']['address1'],
      :city => params['user']['city'],
      :state => params['user']['state'],
      :zip => params['user']['zip']
    }.to_json

    @response = User.put_request("#{@@base_url}/#{@local_user.token}", @body)

    @user = User.update(params[:id], {
      first_name: @response['first_name'],
      last_name: @response['last_name'],
      email: @response['email'],
      token: @response['token']
    }) unless @response['token'].nil?

    respond_to do |format|
      if @response['error_code'].nil?
        flash[:success] = "User successfully updated!"
        format.html { redirect_to user_path(@user) }
        format.json { render :show, status: :created, location: @user }
      else
        flash[:danger] = @response['error_message']
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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

  def get_client_by_token(user_token)
    Client.where(user_token: user_token, store_token: current_store.token)
  end

  def retrieve_user_data(user_token)
    User.get_request("https://shared-sandbox-api.marqeta.com/v3/users/#{user_token}").parsed_response
  end

  private
    def set_local_user
      @local_user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :token)
    end
end
