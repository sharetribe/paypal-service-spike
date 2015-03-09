require 'rubygems'
require 'bundler/setup'

# this will require all the gems not specified to a given group (default)
# and gems specified in your test group
Bundler.require(:default, :development)

require 'sinatra/async'
require 'sinatra/activerecord'

require './utils/entity_utils.rb'
require './utils/hash_utils.rb'
require './utils/url_utils.rb'
require './utils/pattern_matching.rb'

require './models/paypal_account.rb'
require './models/billing_agreement.rb'
require './models/paypal_payment.rb'
require './models/paypal_refund.rb'
require './models/order_permission.rb'
require './models/paypal_ipn_message.rb'
require './models/paypal_process_token.rb'
require './models/paypal_token.rb'

require './paypal_service.rb'

require './config/config_loader.rb'
require './result.rb'

APP_CONFIG = ConfigLoader.load_app_config(
  [
    :paypal_username,
    :paypal_password,
    :paypal_signature,
    :paypal_app_id,
    :paypal_button_source,
    :paypal_endpoint,
    :paypal_expiration_period,
    :paypal_ipn_domain,
    :paypal_ipn_protocol
  ])

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: "localhost",
  username: "sharetribe",
  password: "secret",
  database: "sharetribe_development",
  encoding: "utf8"
)

class Router < Sinatra::Base
  register Sinatra::Async

  Api = PaypalService::API::Api

  # Accounts API

  post '/accounts/request/:community_id' do
    res = Api.accounts.request(body: {
      community_id: params[:community_id],
      person_id: params[:person_id],
      callback_url: params[:callback_url],
      country: params[:country]
                               })

    body { res[:data].to_json }
  end

  post '/accounts/request/:community_id/:person_id' do
    request.body.rewind
    body = HashUtils.symbolize_keys(JSON.parse(request.body.read))
    res = Api.accounts.request(body: {
      community_id: params[:community_id].to_i,
      person_id: params[:person_id],
      callback_url: body[:callback_url],
      country: body[:country]
                               })

    body { res[:data].to_json }
  end

  # post '/accounts/create/:community_id' do
  #   request.body.rewind
  #   body = HashUtils.symbolize_keys(JSON.parse(request.body.read))

  #   res = Api.accounts.create(
  #     community_id: community_id,
  #     person_id: person_id,
  #     order_permission_request_token: params[:order_permission_request_token],
  #     body: {
  #       order_permission_verification_code: body[:order_permission_verification_code]
  #     }
  #   )
  # end

  post '/accounts/create/:community_id/:person_id' do
    request.body.rewind
    body = HashUtils.symbolize_keys(JSON.parse(request.body.read))

    puts "body #{body}"
    puts "params #{params}"

    res = Api.accounts.create(
      community_id: params[:community_id],
      person_id: params[:person_id],
      order_permission_request_token: params[:order_permission_request_token],
      body: {
        order_permission_verification_code: body[:order_permission_verification_code]
      }
    )

    body { res.maybe.or_else({}).to_json }
  end


  delete '/accounts' do
  end

  get '/accounts/:community_id' do
    res = Api.accounts.get(
      community_id: params[:community_id]
    )

    body { Maybe(res[:data]).or_else({}).to_json }
  end

  get '/accounts/:community_id/:person_id' do
    res = Api.accounts.get(
      community_id: params[:community_id],
      person_id: params[:person_id]
    )

    body { Maybe(res[:data]).or_else({}).to_json }
  end

  post '/accounts/billing_agreement/request' do
  end

  post '/accounts/billing_agreement/create' do
  end

  delete '/accounts/billing_agreement' do
  end

  # Payments API

  post '/payments/:community_id/request' do
  end

  post '/payments/:community_id/request/cancel' do
  end

  post '/payments/:community_id/create' do
  end

  post '/payments/:community_id/:transaction_id/full_capture' do
  end

  get '/payments/:community_id/:transaction_id' do
  end

  post '/payments/:community_id/:transaction_id/void' do
  end

  post '/payments/:community_id/:transaction_id/refund' do
  end

  # Billing Agreement API

  post '/billing_agreement/:community_id/:person_id/charge_commission' do
  end

end


