require './lib/stripe_ach.rb'
require './lib/errors.rb'
require './lib/util.rb'
require './lib/actions/bank_account.rb'
require './lib/actions/payment.rb'



StripeAch::api_key = 'sk_test_4YSYfzjIVYUYVJZuVTX85zcn'
customer_id = 'cus_5m4acXkvde3dZA'


list = StripeAch::BankAccount::list(customer_id)

list[:data].each do |bank_account|
  StripeAch::BankAccount::get(customer_id, bank_account[:id])
  StripeAch::BankAccount::delete(customer_id, bank_account[:id])
end


puts StripeAch::BankAccount::list(customer_id)

StripeAch::BankAccount::add(customer_id, '000123456789', '110000000')

puts StripeAch::BankAccount::list(customer_id)


list = StripeAch::BankAccount::list(customer_id)
list[:data].each do |bank_account|
  StripeAch::BankAccount::get(customer_id, bank_account[:id])
  puts StripeAch::BankAccount::updata_metadata(customer_id, bank_account[:id], :hello=>'world')
end


puts StripeAch::BankAccount::list(customer_id)


list = StripeAch::BankAccount::list(customer_id)

list[:data].each do |bank_account|
  puts StripeAch::Payment::create(customer_id, bank_account[:id], 1000, 'usd')
end

