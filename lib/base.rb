# frozen_string_literal: false
require 'yaml'

# Base class for checkouts, which ensure that a couple of operations are performed
#  * All DB migrations are run.
#  * All products, and discounts are inserted into the database.
class Base
  def initialize
    @database = connect
    require_relative './models'
    Sequel.extension :migration
    Sequel::Migrator.run(@database, "#{File.dirname(__FILE__)}/../db/migrations/", use_transactions: false)
    init_database
  end

  # Sum up all transaction, applying discounts, and returning the total
  #
  # @return [Float] The total of all transactions
  def root
    File.expand_path(File.dirname(__FILE__))
  end

  # Simply returns the ruby environment, defaulting to development
  #
  # @return [String] The name of the environment
  def env
    ENV['RUBY_ENV'] || 'development'
  end

  # Returns the environment, defined in config/database.yml as a Hash
  #
  # @return [Hash] The hash of data defined in the environment
  def config
    config = YAML.load_file(File.join(root, '..', 'config', 'database.yml'))[env]
    config
  end

  # Returns a Sequel::Database object associated with the database defined in config/database.yml
  #
  # @return [Sequel::Database] The Sequel database object
  def connect
    Sequel.connect(config['db'])
  end

  # Inserts the defined products into the products table
  #
  # @return nil
  def insert_products
    @database[:products].insert_conflict(:ignore).insert(name: 'Chai', code: 'CH1', price: 3.11)
    @database[:products].insert_conflict(:ignore).insert(name: 'Apples', code: 'AP1', price: 6.00)
    @database[:products].insert_conflict(:ignore).insert(name: 'Coffee', code: 'CF1', price: 11.23)
    @database[:products].insert_conflict(:ignore).insert(name: 'Milk', code: 'MK1', price: 4.75)
  end

  # Inserts the defined discounts into the discounts table
  #
  # @return nil
  def insert_discounts
    [{ limit: -1, code: 'BOGO', source: 'CF1', dest: 'CF1', discount: Product[code: 'CF1'][:price], discount_type: 'bogo' },
     { limit: -1, code: 'APPL', source: 'AP1', dest: 'AP1', discount: 1.50, discount_type: 'appl' },
     { limit: 1, code: 'CHMK', source: 'CH1', dest: 'MK1', discount: Product[code: 'MK1'][:price], discount_type: 'chmk' }].each do |data|
      @database[:discounts].insert_conflict(:ignore).insert(limit: data[:limit], code: data[:code],
                                                            source_product: Product[code: data[:source]][:id],
                                                            destination_product: Product[code: data[:dest]][:id],
                                                            discount: data[:discount],
                                                            discount_type: data[:discount_type])
    end
  end

  def init_database
    insert_products
    insert_discounts
  end
end
