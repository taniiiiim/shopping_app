module TestHelper

  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end

  def is_logged_in?
    !session[:user_id].nil?
  end


    class Rack::Test::CookieJar
      def signed
        self
      end

      def permanent
        self
      end

    end

    def remember(user)
      user.remember
      cookies.permanent.signed[:user_id] = user.id
      cookies.permanent[:remember_token] = user.remember_token
    end

    def current_user
      if (user_id = session[:user_id])
        @current_user ||= User.find_by(id: user_id)
      elsif (user_id = cookies.signed[:user_id])
        user = User.find_by(id: user_id)
        if user && user.authenticated?(:remember, cookies[:remember_token])
          log_in_as user
          @current_user = user
        end
      end
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
