# frozen_string_literal: false
require 'set'
require_relative './special_types'

# The map of specials/discounts
TYPE_MAP = { bogo: BuyOneGetOneFree, appl: BuyXNumberReducePrice, chmk: BuyThisGetThatFree }.freeze

# A specific special that applies to a set of products
class Special
  VALID_OPTIONS = [:code, :destination_product, :discount, :discount_type, :id, :limit, :source_product].freeze

  def initialize(database, options = {})
    # If you're not sending me the right set of of keys associated with the Discount, fail
    invalid_message = "Invalid options #{(VALID_OPTIONS.to_set - options.keys.to_set).to_a}; Valid options are #{VALID_OPTIONS}"
    raise ArgumentError, invalid_message unless options.keys.to_set == VALID_OPTIONS.to_set
    @database = database
    @code = options[:code]
    @destination_product = options[:destination_product]
    @discount = options[:discount]
    @discount_type = TYPE_MAP[options[:discount_type].to_sym]
    @limit = options[:limit]
    @source_product = options[:source_product]
  end

  # Get source and destination products by checkout_id, then initialize the 'discount_type' class, and
  #   find the number of discounts of that specific type, and return an array of the discount amounts
  #
  # @param [Int] Checkout id
  # @return [Array, Float] Array of discount amounts to be subtracted from the total
  def discounts_for_items(checkout_id)
    filtered_products = filter_products(checkout_id)
    return [] if filtered_products.empty?
    total_discounts = @discount_type.new.num_discounts(filtered_products)
    (1..total_discounts).to_a.map { { price: @discount, code: @code } }
  end

  private

  # Take a series of source, and destination products, filter out duplicates, and return an array
  #
  # @param [Array, Array] Source, and Destination product arrays to filter, and combine
  # @return [Array] An array of filtered source and destination products
  def combine_products(source, destination)
    products = []
    source.each do |s|
      products.push(s)
    end
    destination.each do |d|
      products.push(d)
    end
    Set.new(products).to_a
  end

  # Filter products by checkout_id, finding all of the source, and destination products that
  #   could potentially constitute a discount
  #
  # @param [Int] Checkout id for which to search
  # @return [Array] An array of products
  def filter_products(checkout_id)
    source_products = @database[:transactions].where(
      product_id: @source_product,
      checkout_id: checkout_id
    )
    destination_products = @database[:transactions].where(
      product_id: @destination_product,
      checkout_id: checkout_id
    )
    combine_products(source_products, destination_products)
  end
end
