# frozen_string_literal: false
require 'sequel'

# Sequel Model for Products
class Product < Sequel::Model(:products)
  set_primary_key [:id]
end

# Sequel Model for Discounts
class Discounts < Sequel::Model(:discounts)
  set_primary_key [:id]
end

# Sequel Model for Transactions
class Transactions < Sequel::Model(:transactions)
  set_primary_key [:id]
end
