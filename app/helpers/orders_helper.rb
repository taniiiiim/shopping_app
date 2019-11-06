module OrdersHelper

  def product_price(order)
    details = order.details
    p = Array.new
    details.each do |d|
      p << Product.find(d.product_id).price
    end
    return p
  end

  def product_amount(order)
    details = order.details
    a = Array.new
    details.each do |d|
      a << d.amount
    end
    return a
  end

  def inner_product(a, b)
    i = 0
    p = 0
    while i < a.length
      p += a[i] * b[i]
      i += 1
    end
    return p
  end

  def sum(order)
    inner_product(product_price(order), product_amount(order))
  end

end
