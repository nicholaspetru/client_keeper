class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  @@base_url = "https://shared-sandbox-api.marqeta.com/v3/users/"

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    puts "user: #{@user}"
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
    @user = User.new(user_params)

    @body = {
      :first_name => @user.first_name,
      :last_name => @user.last_name,
      :email => @user.email,
      :balance => @user.balance
    }.to_json

    @response = User.make_request(@@base_url, @body)
    puts @response['token']
    @user.token = @response['token']

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
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
      params.require(:user).permit(:first_name, :last_name, :email, :balance)
    end
end
