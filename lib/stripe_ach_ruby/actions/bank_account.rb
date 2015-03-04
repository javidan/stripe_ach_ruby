module StripeAch
  module BankAccount
    def self.list(customer_id)
      url = Util.url('customers', customer_id, 'bank_accounts')
      StripeAch::request(url)
    end

    def self.get(customer_id, bank_account_id)
      url = Util.url('customers', customer_id, 'bank_accounts', bank_account_id)
      StripeAch::request(url)
    end

    def self.delete(customer_id, bank_account_id)
      url = Util.url('customers', customer_id, 'bank_accounts', bank_account_id)
      StripeAch::request(url, :delete)
    end

    def self.add(customer_id, account_number, routing_number, country='US')

      url = Util.url('customers', customer_id, 'bank_accounts')

      account_details = {
        'bank_account[account_number]'=> account_number,
        'bank_account[routing_number]'=> routing_number,
        'bank_account[country]'=> country
      }

      StripeAch::request(url, :post, account_details)
    end

    def self.add_by_token(token)

      url = Util.url('customers', customer_id, 'bank_accounts')

      account_details = {
        'bank_account'=> token
      }

      StripeAch::request(url, :post, account_details)
    end

    def self.updata_metadata(customer_id, bank_account_id, metadata)
      url = Util.url('customers', customer_id, 'bank_accounts', bank_account_id)
      result = {}
      metadata = metadata.each{|key, value| result["metadata[#{key}]"] = value}

      StripeAch::request(url, :post, result)
    end

    def self.verify(customer_id, bank_account_id, amount1, amount2)
      url = Util.url('customers', customer_id, 'bank_accounts', bank_account_id, 'verify')

      verification_details = {
        'amounts[]'=> amount1,
        'amounts[]'=> amount2
      }

      StripeAch::request(url, :post, verification_details)

    end
  end
end