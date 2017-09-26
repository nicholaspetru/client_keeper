class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  @@base_url = "https://shared-sandbox-api.marqeta.com/v3/users/"

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user ||= User.make_request(@@base_url + @user.token)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
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
      token: @response['token'],
    ) if !@response['token'].nil?

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

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :token)
    end
end
