[![Build Status][BS img]](https://travis-ci.org/saveriomiroddi/json_on_rails)
[![Coverage Status][CS img]](https://coveralls.io/r/saveriomiroddi/json_on_rails)

# JSON on Rails

This gem adds native support for MySQL [5.7] JSON data type to Rails 4.

## Introduction

Rails 5 introduced native support for the [MySQL] JSON data type; however, due to the Rails feature policy, version 4 won't be receive this functionality.

This gem adds a Rails JSON data type, allowing the user to work with JSON attributes transparently, as a Array/Hash/etc.

The inner working is simple, and uses the standard Rails (internal) APIs; this is explained in a [blog post of mine](https://saveriomiroddi.github.io/Support-MySQL-native-JSON-data-type-in-Rails-4).

## Installation

Add the gem to the Gemfile of your rails project:

```ruby
gem "json_on_rails", "~> 0.1.1"
```

and update the environment:

```sh
$ bundle install
```

that's all!

## Usage/example

Create a table:

```
class CreateUsers < ActiveRecord::Migration
  def up
    create_table "migration_models" do |t|
      t.string "login", null: false, limit: 24
      t.json "extras"
    end
  end
end
```

or add the column to an existing one:

```
class CreateUsers < ActiveRecord::Migration
  def up
    add_column "users", "extras", :json
  end
end
```

define the model:

```
class User < ActiveRecord::Base
  attribute :extras, ActiveRecord::Type::Json.new
end

```

then (ab)use the new attribute!:

```ruby
user = User.create!(login: "saverio", extras: {"uses" => ["mysql", "json"]})
user.extras.fetch("uses") # => ["mysql", "json"]
```

Don't forget that JSON doesn't support symbols, therefore, they can be set, but are accessed/loaded as strings.

Users are encouraged to have a look at the test suite ([here](spec/json_on_rails/json_attributes_spec.rb) and [here](spec/json_on_rails/arel_methods_spec.rb)) for an exhaustive view of the functionality.

[BS img]: https://travis-ci.org/saveriomiroddi/json_on_rails.svg?branch=master
[CS img]: https://coveralls.io/repos/saveriomiroddi/json_on_rails/badge.png?branch=master
