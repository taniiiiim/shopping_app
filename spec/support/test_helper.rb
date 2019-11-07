module TestHelper

  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

  def current_order
    if (order_id = cookies.signed[:order_id])
      order = Order.find_by(id: order_id)
      if order && order.authenticated?(:order, cookies[:order_token])
        @current_order = order
      end
    end
  end

  def current_order?(order)
    order == current_order
  end

  def any_carts?
    !current_order.nil?
  end

  def cancel(order)
    order.cancel if order
    cookies.delete(:order_id)
    cookies.delete(:order_token)
  end

  def destroy_cart
    cancel(current_order)
    @current_order = nil
  end



end
