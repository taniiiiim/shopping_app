class OrderMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_create.subject
  #
  def order_create(order)
    @order = order
    @user = User.find(@order.user_id)
    mail to: @user.email, subject: "Thank you for the order!"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_update.subject
  #
  def order_update(order)
    @order = order
    @user = User.find(@order.user_id)
    mail to: @user.email, subject: "Order destination changed!"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_delete.subject
  #
  def order_delete(order)
    @order = order
    @user = User.find(@order.user_id)
    mail to: @user.email, subject: "Order canceled!"
  end
end
