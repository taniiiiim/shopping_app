module CartHelper

  def order_products(order)
    details = order.details
    p = Array.new
    details.each do |d|
      p << Product.find(d.product_id).id
    end
    return p
  end

  def reduce_stocks(order)
    order_products(order).each do |p|
      stock = Stock.find_by(product_id: p)
      amount = order.details.find_by(product_id: p).amount
      stock.stock -= amount
      stock.save
    end
  end

  def create_cart(order)
    order.create_cart
    cookies.signed[:order_id] = { value:   order.id, expires: 30.minutes.from_now }
    cookies[:order_token] = { value:   order.order_token, expires: 30.minutes.from_now }
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
      cancel(current_order) if
      @current_order = nil
    end


end
