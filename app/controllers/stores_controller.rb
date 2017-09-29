class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  @@merchant_start_count = 1

  def index
    @stores = Store.all
  end

  def show
    @page_store = Store.find(params[:id])
    if logged_in?
      @store = Store.get_request("stores/" + current_store.token)
    end
  end

  def new
    @store = Store.new
  end

  def edit
  end

  def create
    @body = {
      :name => params['store']['name'],
      :state => params['store']['state'],
      :city => params['store']['city'],
      :address1 => params['store']['address1'],
      :zip => params['store']['zip'],
      :mid => rand((10 ** 15) - 1),
      :contact_email => params['store']['contact_email'],
      :active => params['store']['active'],
      :merchant_token => get_merchant_token
    }.to_json

    @response = Store.post_request("stores/", @body)
    while @response['error_code'] == "400101"
      @body['mid'] = rand((10 ** 15) - 1)
      @response = Store.post_request("stores/", @body)
    end

    @store = Store.create(
      name: @response['name'],
      token: @response['token'],
      username: params['store']['username'],
      password: params['store']['password']
    ) if !@response['token'].nil?

    respond_to do |format|
      if @store.save
        login @store
        flash[:success] = "New store successfully created!"
        format.html { redirect_to @store }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_merchant_token
    response = Store.get_request("merchants?count=1&start_index=#{@@merchant_start_count}")
    @@merchant_start_count += 1 if response['data']
    if response['data']
      response['data'][0]['token']
    else
      "05e63015-202b-4af6-bac2-e18d9e89b4f0"
    end
  end

  def update
    #TODO: updating store does yet not PUT to APIs
    respond_to do |format|
      # put request instead
      if @store.update(store_params)
        flash[:success] = "Store successfully updated"
        format.html { redirect_to @store }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    helper_method :get_merchant_token
    def set_store
      @store = Store.find(params[:id])
    end

    def store_params
      params.require(:store).permit(:name, :token, :username, :password)
    end
end
