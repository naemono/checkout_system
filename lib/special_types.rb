# frozen_string_literal: false
require 'set'

# Buy one get one free discount type
class BuyOneGetOneFree
  def num_discounts(products)
    products.length / 2
  end
end
# Buy 'x' number of items, get a discount on each.
class BuyXNumberReducePrice
  def initialize
    @num = 3
  end

  # Find the number of discounted products, from the instance variable @num upon initialization
  #
  # @param [Array] Array of models.Product
  # @return [Int] The number of discounts per this product
  def num_discounts(products)
    if products.length < @num
      0
    else
      products.length
    end
  end
end
# Buy one of these items, get another free
class BuyThisGetThatFree
  # Finds all product codes from the array of items, failing if it's not == 2
  #
  # @param [Array] Array of models.Product
  # @return [Int] The number of discounts per this product
  # @raise ArgumentError, if an invalid number of distinct items was sent to method
  def num_discounts(products)
    types = get_all_product_codes(products)
    # this is getting the count of distinct items in the list.
    res = Hash[types.group_by { |x| x }.map { |k, v| [k, v.count] }]
    if res.keys.length != 2
      raise ArgumentError, "Too many distinct products sent to 'Buy one get one free' Discount type."
    end
    res[res.keys[0]] < res[res.keys[1]] ? res[res.keys[0]] : res[res.keys[1]]
  end

  private

  # Gets all product codes from a Product model
  #
  # @param [Array] Array of models.Product
  # @return [Array] The Product codes
  def get_all_product_codes(products)
    types = []
    products.each do |product|
      types.push(product[:product_id])
    end
    types
  end
end
