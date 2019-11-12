module OrdersHelper

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

  def recover_stocks(order)
    order_products(order).each do |p|
      stock = Stock.find_by(product_id: p)
      amount = order.details.find_by(product_id: p).amount
      stock.stock += amount
      stock.save
    end
  end

  def stocks_exist?(order)
    i = 0
    p = true
    stock = product_stock(order)
    amount = product_amount(order)
    while i < stock.length
      break unless (p = (amount[i] <= stock[i]))
      i += 1
    end
    return p
  end

  def product_stock(order)
    details = order.details
    s = Array.new
    details.each do |d|
      s << Stock.find_by(product_id: d.product_id).stock
    end
    return s
  end

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
