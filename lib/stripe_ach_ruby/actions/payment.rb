module StripeAch
  module Payment
    def self.create(customer_id, bank_account_id, amount, currency='usd', metadata={})
      url = Util.url('payments')

      payment_details = {
        'customer'=> customer_id,
        'bank_account'=> bank_account_id,
        'currency'=> currency,
        'amount'=> amount,
        'payment_method'=> 'ach',
        'metadata' => metadata
      }

      StripeAch::request(url, :post, payment_details)
    end
  end
end