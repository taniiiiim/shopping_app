# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/order_create
  def order_create
    OrderMailer.order_create
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/order_update
  def order_update
    OrderMailer.order_update
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/order_delete
  def order_delete
    OrderMailer.order_delete
  end

end
