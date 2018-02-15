[![Build Status](https://travis-ci.org/saveriomiroddi/json_on_rails.svg?branch=master)](https://travis-ci.org/saveriomiroddi/json_on_rails)
[![Coverage Status](https://coveralls.io/repos/github/saveriomiroddi/json_on_rails/badge.svg?branch=master)](https://coveralls.io/github/saveriomiroddi/json_on_rails?branch=master)

# JSON on Rails

This gem adds native support for MySQL [5.7] JSON data type to Rails 4.

## Introduction

Rails 5 introduced native support for the [MySQL] JSON data type; however, due to the Rails feature policy, version 4 won't receive this functionality.

This gem adds a Rails JSON data type, allowing the user to work with JSON attributes transparently, as a Array/Hash/etc.

The inner working is simple, and uses the standard Rails (internal) APIs; this is explained in a [blog post of mine](https://saveriomiroddi.github.io/Support-MySQL-native-JSON-data-type-in-Rails-4).

## Installation

Add the gem to the Gemfile of your rails project:

```ruby
gem "json_on_rails", "~> 0.2.0"
```

and update the environment:

```sh
$ bundle install
```

Change the `mysql` connection adapter to `mysql2_json`, in `config/database.yml`:

```yaml
default: &default
  adapter: mysql2_json
```

that's all!

## Usage/example

Create a table:

```
class CreateUsers < ActiveRecord::Migration
  def change
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
  def change
    add_column "users", "extras", :json
  end
end
```

define the model (rails will automatically pick up the data type):

```
class User < ActiveRecord::Base; end
```

then (ab)use the new attribute!:

```ruby
User.create!(login: "saverio", extras: {"uses" => ["mysql", "json"]})
# ...
User.last.extras.fetch("uses") # => ["mysql", "json"]
```

The schema can be dumped as usual; json columns will be transparently included:

```sh
$ rake db:schema:dump
$ cat db/schema.rb
ActiveRecord::Schema.define(version: 0) do

  create_table "users", force: :cascade do |t|
    t.json   "extras"
  end

end
```

## Caveats/further documentation

### MySQL SELECT DISTINCT JSON bug (**IMPORTANT!**)

MySQL versions up to at least 5.7.12 have a serious JSON bug.

In some cases, queries using DISTINCT on VARCHAR and JSON columns will not perform the deduplication, resulting in duplicate rows being returned, if there are any.

This has been fixed between 5.7.13 and 5.7.18 (I couldn't find the related enty in the release notes), therefore, MySQL 5.7 users are urged to upgrade to a recent version if they use JSON columns.

### Documentation

Users are encouraged to have a look at the test suite (especially [here](spec/json_on_rails/json_attributes_spec.rb) and [here](spec/json_on_rails/arel_methods_spec.rb)) for an exhaustive view of the functionality.

### JSON Symbols

Don't forget that JSON doesn't support symbols, therefore, they can be set, but are accessed/loaded as strings.

### MySQL decimal normalization

MySQL (up to 8.0.3, included) will normalize decimal numbers with zero fractional (e.g. `5.0`) to integers, therefore, changing the data type on save.

See [relevant bug](https://bugs.mysql.com/bug.php?id=88230).
