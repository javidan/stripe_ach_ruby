## Stripe Ach Client

### Usage
add to gemfile

    gem 'stripe_ach_ruby', git: 'https://github.com/javidan/stripe_ach_ruby'


Example usage

   
    StripeAch::api_key = 'secret_key'
    customer_id = 'cus_12345'
    
    #list bank accounts
    list = StripeAch::BankAccount::list(customer_id)

    list[:data].each do |bank_account|
       StripeAch::BankAccount::get(customer_id, bank_account[:id])
       StripeAch::BankAccount::delete(customer_id, bank_account[:id])
    end

### Bank Account
#### List Bank Acounts

    list = StripeAch::BankAccount::list(customer_id)

#### Get bank account

    StripeAch::BankAccount::get(customer_id, bank_account_id)

#### Delete bank account
     
    StripeAch::BankAccount::delete(customer_id, bank_account_id)

#### Add bank account
    StripeAch::BankAccount::add(customer_id, account_number, routing_number, country)

**country** is optional, default: us

#### Update metadata on bank account

     StripeAch::BankAccount::updata_metadata(customer_id, bank_account_id, :hello=>'world')

#### Verify bank account

    StripeAch::BankAccount::verify(customer_id, bank_account_id, amount1, amount2)


#### Create payment

    StripeAch::Payment::create(customer_id, bank_account_id, amount_in_cents, currency)
 
 **currency** default is **usd**
