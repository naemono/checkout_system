# frozen_string_literal: false
require 'sequel'

Sequel.migration do
  change do
    create_table(:products) do
      primary_key :id
      String :name
      String :code, unique: true
      Float :price
    end
    create_table(:discounts) do
      primary_key :id
      String :code, unique: true
      String :discount_type
      Integer :limit
      foreign_key :source_product
      foreign_key :destination_product
      Float :discount
    end
    create_table(:transactions) do
      primary_key :id
      Integer :checkout_id
      foreign_key :product_id
      foreign_key :discount_id
    end
  end
end
