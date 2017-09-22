class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  @@base_url = "https://shared-sandbox-api.marqeta.com/v3/stores/"

  # GET /stores
  def index
    @stores = Store.all
  end

  # GET /stores/1
  def show
    puts "store: #{@store}"
    @store ||= Store.make_request(@@base_url + @store.token)
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  def create
    @store = Store.new(store_params)

    if !@store.username.nil? && !@store.password.nil?
      @store[:claimed] = true
    end

    @body = {
      :name => @store.name,
      :token => @store.token,
      :contact_email => @store.contact_email,
      :username => @store.username,
      :password => @store.password,
      :active => @store.active
    }.to_json

    respond_to do |format|
      if @store.save
        flash[:success] = "New store successfully created!"
        format.html { redirect_to @store }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  def update
    if !@store.username.nil? && !@store.password.nil?
      puts 'STORE CLAIMED'
      @store[:claimed] = true
    end
    respond_to do |format|
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

  # DELETE /stores/1
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_store
      @store = Store.find(params[:id])
    end

    def store_params
      params.require(:store).permit(:name, :contact_email, :active, :token, :username, :password, :claimed)
    end
end
