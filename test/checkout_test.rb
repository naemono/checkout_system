# frozen_string_literal: false
ENV['RUBY_ENV'] = 'test'
require 'minitest/autorun'
require_relative '../lib/checkout'
require_relative '../lib/special'

# Tests for Checkout class
class TestCheckout < Minitest::Test
  def setup
    @checkout = Checkout.new
  end

  def teardown
    @checkout = Checkout.new
    @checkout.database.drop_table(:products)
    @checkout.database.drop_table(:discounts)
    @checkout.database.drop_table(:transactions)
    @checkout.database.drop_table(:schema_migrations)
  end

  def test_checkout_init
    refute_nil @checkout.database
    refute_nil @checkout.checkout_id
  end

  def test_database_products_init
    assert_equal @checkout.database[:products][code: 'CH1'], id: 1, name: 'Chai', code: 'CH1', price: 3.11
    assert_equal @checkout.database[:products][code: 'AP1'], id: 2, name: 'Apples', code: 'AP1', price: 6.00
    assert_equal @checkout.database[:products][code: 'CF1'], id: 3, name: 'Coffee', code: 'CF1', price: 11.23
    assert_equal @checkout.database[:products][code: 'MK1'], id: 4, name: 'Milk', code: 'MK1', price: 4.75
  end

  def test_database_discounts_init
    coffee = @checkout.database[:products][name: 'Coffee']
    apples = @checkout.database[:products][name: 'Apples']
    chai = @checkout.database[:products][name: 'Chai']
    milk = @checkout.database[:products][name: 'Milk']
    assert_equal(
      @checkout.database[:discounts][code: 'BOGO'],
      id: 1,
      limit: -1,
      code: 'BOGO',
      source_product: coffee[:id],
      destination_product: coffee[:id],
      discount: 11.23,
      discount_type: 'bogo'
    )
    assert_equal(
      @checkout.database[:discounts][code: 'APPL'],
      id: 2, limit: -1,
      code: 'APPL',
      source_product: apples[:id],
      destination_product: apples[:id],
      discount: 1.50,
      discount_type: 'appl'
    )
    assert_equal(
      @checkout.database[:discounts][code: 'CHMK'],
      id: 3,
      limit: 1,
      code: 'CHMK',
      source_product: chai[:id],
      destination_product: milk[:id],
      discount: 4.75,
      discount_type: 'chmk'
    )
  end

  def test_checkout_init_specials
    refute_empty @checkout.specials
    assert_kind_of Array, @checkout.specials
    assert_kind_of Special, @checkout.specials[0]
  end

  def test_buy_one_coffee
    %w(CF1).each { |code| @checkout.scan code }
    assert_equal 11.23, @checkout.sum
  end

  def test_buy_one_get_one_free_coffee
    %w(CF1 CF1).each { |code| @checkout.scan code }
    assert_equal 11.23, @checkout.sum
  end

  def test_buy_one_get_one_free_coffee_triple
    %w(CF1 CF1 CF1).each { |code| @checkout.scan code }
    assert_equal 22.46, @checkout.sum
  end

  def test_buy_one_get_one_free_coffee_quad
    %w(CF1 CF1 CF1 CF1).each { |code| @checkout.scan code }
    assert_equal 22.46, @checkout.sum
  end

  def test_buy_3_apples_reduce_price
    %w(AP1 AP1 AP1).each { |code| @checkout.scan code }
    assert_equal 4.50 * 3, @checkout.sum
  end

  def test_buy_6_apples_reduce_price
    %w(AP1 AP1 AP1 AP1 AP1 AP1).each { |code| @checkout.scan code }
    assert_equal 4.50 * 6, @checkout.sum
  end

  def test_buy_2_apples_does_not_reduce_price
    %w(AP1 AP1).each { |code| @checkout.scan code }
    assert_equal 6.00 * 2, @checkout.sum
  end

  def test_buy_chai_get_milk_free
    %w(CH1 MK1).each { |code| @checkout.scan code }
    assert_equal 3.11, @checkout.sum
  end
end
