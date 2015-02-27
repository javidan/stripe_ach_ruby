require 'stripe_ach_ruby/rest_client'
require 'stripe_ach_ruby/errors.rb'
require 'stripe_ach_ruby/util.rb'
require 'stripe_ach_ruby/actions/bank_account.rb'
require 'stripe_ach_ruby/actions/payment.rb'




module StripeAch
  class << self
    attr_accessor :api_key
    attr_reader :base_url
  end

  def self.base_url
    "https://#{api_key}:@api.stripe.com/v1"
  end
  
  def self.request(url, method=:get, params={})

    unless @api_key
      raise StripeAchError.new('No API key provided. 
        Set your API key using "Stripe.api_key = <API-KEY>". 
        You can generate API keys from the Stripe web interface.
        See https://stripe.com/api for details, or email support@stripe.com
        if you have any questions.')
    end

    # unless @customer_id
    #   raise StripeAchError.new('No Customer id Provided')
    # end



    parse(request_rest_client(url, method, params))
  end

  def self.request_rest_client(url, method=:get, params={})

    url = Util.url(base_url, url)

    begin
       return RestClient.get url, params if method == :get
       return RestClient.post url, params if method == :post
       return RestClient.put url, params if method == :put
       return RestClient.delete url, params if method == :delete
    rescue SocketError => e
      handle_restclient_error(e, api_base_url)
    rescue NoMethodError => e
    
    rescue RestClient::ExceptionWithResponse => e
      if rcode = e.http_code and rbody = e.http_body
        handle_api_error(rcode, rbody)
      else
        handle_restclient_error(e, api_base_url)
      end
    rescue RestClient::Exception, Errno::ECONNREFUSED => e
      handle_restclient_error(e, api_base_url)
    end

  end

  def self.handle_restclient_error(e, api_base_url=nil)
    api_base_url = base_url unless api_base_url
    connection_message = "Please check your internet connection and try again. 
      If this problem persists, you should check Stripe's service status at
      https://twitter.com/stripestatus, or let us know at support@stripe.com."
  
    case e
      when RestClient::RequestTimeout
        message = "Could not connect to Stripe (#{api_base_url}). #{connection_message}"
      when RestClient::ServerBrokeConnection
        message = "The connection to the server (#{api_base_url}) broke before the request completed. #{connection_message}"
      when RestClient::SSLCertificateNotVerified
        message = "Could not verify Stripe's SSL certificate. 
          Please make sure that your network is not intercepting certificates.
          (Try going to https://api.stripe.com/v1 in your browser.)
          If this problem persists, let us know at support@stripe.com."
      when SocketError
        message = "Unexpected error communicating when trying to connect to Stripe. 
          You may be seeing this message because your DNS is not working.
          To check, try running 'host stripe.com' from the command line."
      else
        message = "Unexpected error communicating with Stripe.
          If this problem persists, let us know at support@stripe.com."
    end
      raise StandardError.new(message + "\n\n(Network error: #{e.message})")
    end

  def self.handle_api_error(rcode, rbody)
    begin
      error_obj = JSON.parse(rbody)
      error_obj = Util.symbolize_names(error_obj)
      error = error_obj[:error] or raise StripeAchError.new # escape from parsing
    rescue JSON::ParserError, StripeAchError
      raise general_api_error(rcode, rbody)
    end
    
    case rcode
    when 400, 404
     raise invalid_request_error error, rcode, rbody, error_obj
    when 401
      raise authentication_error error, rcode, rbody, error_obj
    when 402
      raise card_error error, rcode, rbody, error_obj
    else
      raise api_error error, rcode, rbody, error_obj
    end
  end

  def self.general_api_error(rcode, rbody)
    StripeAchError.new("Invalid response object from API: #{rbody.inspect} (HTTP response code was #{rcode})", rcode, rbody)
  end

  def self.invalid_request_error(error, rcode, rbody, error_obj)
    InvalidRequestError.new(error[:message], error[:param], rcode, rbody, error_obj)
  end

  def self.authentication_error(error, rcode, rbody, error_obj)
    StripeAchError.new(error[:message], rcode, rbody, error_obj)
  end

  def self.card_error(error, rcode, rbody, error_obj)
    StripeAchError.new(error[:message], error[:param], error[:code], rcode, rbody, error_obj)
  end

  def self.api_error(error, rcode, rbody, error_obj)
    StripeAchError.new(error[:message], rcode, rbody, error_obj)
  end

  def self.parse(response)
  begin
    # Would use :symbolize_names => true, but apparently there is
    # some library out there that makes symbolize_names not work.
    response = JSON.parse(response.body)
  rescue JSON::ParserError
    raise general_api_error(response.code, response.body)
  end
    Util.symbolize_names(response)
  end

end