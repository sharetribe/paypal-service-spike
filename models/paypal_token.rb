# == Schema Information
#
# Table name: paypal_tokens
#
#  id                   :integer          not null, primary key
#  community_id         :integer          not null
#  token                :string(64)
#  transaction_id       :integer
#  merchant_id          :string(255)      not null
#  receiver_id          :string(255)      not null
#  created_at           :datetime
#  item_name            :string(255)
#  item_quantity        :integer
#  item_price_cents     :integer
#  currency             :string(8)
#  express_checkout_url :string(255)
#  shipping_total_cents :integer
#
# Indexes
#
#  index_paypal_tokens_on_community_id    (community_id)
#  index_paypal_tokens_on_token           (token) UNIQUE
#  index_paypal_tokens_on_transaction_id  (transaction_id)
#

class PaypalToken < ActiveRecord::Base
  validates_presence_of :community_id, :token, :transaction_id, :merchant_id, :express_checkout_url
  # attr_accessible(
  #   :community_id,
  #   :token,
  #   :transaction_id,
  #   :merchant_id,
  #   :item_name,
  #   :item_quantity,
  #   :item_price,
  #   :currency,
  #   :express_checkout_url,
  #   :receiver_id,
  #   :shipping_total
  # )

  def item_price
    Money.new(item_price, currency)
  end

  def item_price=(m)
    item_price_cents = m.cents
    currency = m.currency.iso_code
  end
  def shipping_total
    Money.new(shipping_total, currency)
  end

  def shipping_total=(m)
    shipping_total_cents = m.cents
    currency = m.currency.iso_code
  end
end