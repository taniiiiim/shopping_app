namespace :clean_cart do
  desc "clean orders table in which orders are not confirmed and expired"

  task clean_cart: :environment do
    orders = Order.where("ordered = ? and cart_created_at <= ?", false, Time.zone.now - 30.minutes)
    if orders
      orders.each do |o|
      o.destroy
      end
    end
  end

end
