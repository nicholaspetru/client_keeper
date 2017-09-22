module SessionsHelper
  def login(store)
    session[:store_id] = store.id
  end

  def logged_in?
    !current_store.nil?
  end

  def current_store
    @current_store ||= Store.find_by(id: session[:store_id])
  end

  def logout
    session.delete(:store_id)
    @current_user = nil
  end
end
