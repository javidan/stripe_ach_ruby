## Stripe Ach Client

Ruby Api client for Stripe ACH

[For Api documentation check here](https://gist.github.com/raycmorgan/166e899cbb359768ad29) 

### Usage
add to gemfile
```ruby
gem 'stripe_ach_ruby', git: 'https://github.com/javidan/stripe_ach_ruby'
```

Example usage

```ruby
StripeAch::api_key = 'secret_key'
customer_id = 'cus_12345'

#list bank accounts
list = StripeAch::BankAccount::list(customer_id)

list[:data].each do |bank_account|
   StripeAch::BankAccount::get(customer_id, bank_account[:id])
   StripeAch::BankAccount::delete(customer_id, bank_account[:id])
end
```

### Bank Account
#### List Bank Acounts

```ruby
list = StripeAch::BankAccount::list(customer_id)
```

#### Get bank account

```ruby
StripeAch::BankAccount::get(customer_id, bank_account_id)
```

#### Delete bank account
```ruby
StripeAch::BankAccount::delete(customer_id, bank_account_id)
```

#### Add bank account
```ruby
StripeAch::BankAccount::add(customer_id, account_number, routing_number, country)
```

You can also add bank account by Stripe token
```ruby
StripeAch::BankAccount::add_by_token(customer_id, token)
```

**country** is optional, default: 'us'

#### Update metadata on bank account
```ruby
StripeAch::BankAccount::updata_metadata(customer_id, bank_account_id, :hello=>'world')
```

#### Verify bank account

```ruby
StripeAch::BankAccount::verify(customer_id, bank_account_id, amount1, amount2)
```

#### Create payment
```ruby
StripeAch::Payment::create(customer_id, bank_account_id, amount_in_cents, currency, metadata)
 ```

 **currency** is optional, default is **'usd'**
 **metadata** is optional, default is empty
