# frozen_string_literal: false
require 'command_line_reporter'
require 'sequel'
require_relative './base'
require_relative './special'

# Class to hold a list of items to be calculated at a future date
#   for a total price.
class Checkout < Base
  attr_reader :database, :checkout_id, :specials

  include CommandLineReporter

  def initialize
    super
    @checkout_id = generate_checkout_id
    @specials = initialize_specials
  end

  # Scan item using it's code, inserting a transaction into the database.
  #
  # @param [String] The item's code to process
  # @return nil
  # @raise ArgumentError, if the item's code was not found
  def scan(item)
    product = Product[code: item]
    raise ArgumentError, "Item code #{item} not found" unless product
    Transactions.insert(
      checkout_id: @checkout_id,
      product_id: product[:id]
    )
  end

  # Sum up all transaction, applying discounts, and returning the total
  #
  # @return [Float] The total of all transactions
  def sum
    total = 0.0
    discounts = apply_specials.flatten
    Transactions.where(checkout_id: @checkout_id).each do |t|
      total += Product[id: t[:product_id]][:price]
    end
    discounts.each do |d|
      total -= d[:price]
    end
    total.round(2)
  end

  # Produce a line-itemed receipt of items, and discounts, with a final total.
  #
  # @return [nil]
  def receipt
    running_total = 0.0
    discounts = apply_specials.flatten
    discounts.each do |d|
      running_total -= d[:price]
    end
    table(border: true) do
      row do
        column('Item', width: 20)
        column('Discount', width: 30, align: 'right', padding: 5)
        column('Price', width: 15)
      end
      Transactions.where(checkout_id: @checkout_id).each do |t|
        running_total += Product[id: t[:product_id]][:price]
        row do
          column(Product[id: t[:product_id]][:code])
          column('')
          column(Product[id: t[:product_id]][:price])
        end
      end
      discounts.each do |d|
        row do
          column('')
          column(d[:code])
          column(d[:price])
        end
      end
      row do
        column('Total')
        column('')
        column(running_total.round(2))
      end
    end
  end

  private

  # Find all specials associated with a checkout id, and verify if any apply
  #
  # @return [Array, Float] Cost of each discount to subtract from total
  def apply_specials
    specials.map { |special| special.discounts_for_items(@checkout_id) }
  end

  # Find all specials in Discounts table, and return them
  #
  # @return [Array, Special] Array of Special model
  def initialize_specials
    specials = []
    Discounts.each do |discount|
      specials.push(Special.new(@database, **discount))
    end
    specials
  end

  # Generate a checkout id from the most recent in Database we can associated
  #   with every transaction
  #
  # @return [Int] Checkout id
  def generate_checkout_id
    last_id = Transactions.order(:checkout_id).last
    last_id.nil? ? 0 : last_id[:checkout_id] + 1
  rescue Sequel::DatabaseError
    0
  end
end
