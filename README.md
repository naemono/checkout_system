# Ruby Checkout System
Ruby test project to implement a checkout system, with a sqlite backend, and allowing specials/discounts

## Installation

### Install Ruby/rvm
```
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
$ \curl -sSL https://get.rvm.io | bash -s stable
```

### Install dependencies
```
$ gem install bundler
$ bundle install
```

### Example Usage
```
$ irb
2.4.1 :001 > require_relative './lib/checkout'
2.4.1 :002 > checkout = Checkout.new
2.4.1 :003 > %w(AP1 AP1 AP1 AP1 AP1 AP1).each { |code| checkout.scan code }
2.4.1 :004 > checkout.receipt
┏━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━┓
┃ Item                 ┃                  Discount      ┃ Price           ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃ AP1                  ┃                                ┃ 6.0             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃ AP1                  ┃                                ┃ 6.0             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃ AP1                  ┃                                ┃ 6.0             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃ AP1                  ┃                                ┃ 6.0             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃ AP1                  ┃                                ┃ 6.0             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃ AP1                  ┃                                ┃ 6.0             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃                      ┃                      APPL      ┃ 1.5             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃                      ┃                      APPL      ┃ 1.5             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃                      ┃                      APPL      ┃ 1.5             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃                      ┃                      APPL      ┃ 1.5             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃                      ┃                      APPL      ┃ 1.5             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃                      ┃                      APPL      ┃ 1.5             ┃
┣━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╊━━━━━━━━━━━━━━━━━┫
┃ Total                ┃                                ┃ 27.0            ┃
┗━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━━━━━━━━━━━━━┛
2.4.1 :005 > checkout.sum
 => 27.0
```

### Testing
Automated
```
$ rake
```

Or Manually
```
$ ruby test/*_test.rb
```


### Coverage Report
After test run
```
$ rake
```
Point web browser at file:///Path/To/Checkout/Dir/coverage/index.html
