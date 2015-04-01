Gem::Specification.new do |s|
  s.name        = 'stripe_ach_ruby'
  s.version     = '0.1.5'
  s.date        = '2014-02-28'
  s.summary     = "Stripe ACH ruby client"
  s.description = "This is a client for Stripe ACH interface"
  s.authors     = ["Javidan Guliyev"]
  s.email       = 'q.cavidan@gmail.com'
  s.files       = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/javidan/stripe_ach_ruby'


  s.add_dependency('rest-client', '~> 1.7')
  s.add_dependency('json', '~> 1.8.1')
  
  s.license       = 'MIT'
end