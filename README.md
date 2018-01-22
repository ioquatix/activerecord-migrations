# ActiveRecord::Migrations

This gem provides opinionated support for ActiveRecord migrations in non-Rails applications. It's more opinionated than [active_record_migrations](https://github.com/rosenfeld/active_record_migrations) and [standalone-migrations](https://github.com/thuss/standalone-migrations), and therefore simpler to configure.

[![Build Status](https://secure.travis-ci.org/ioquatix/activerecord-migrations.svg)](http://travis-ci.org/ioquatix/activerecord-migrations)
[![Code Climate](https://codeclimate.com/github/ioquatix/activerecord-migrations.svg)](https://codeclimate.com/github/ioquatix/activerecord-migrations)
[![Coverage Status](https://coveralls.io/repos/ioquatix/activerecord-migrations/badge.svg)](https://coveralls.io/r/ioquatix/activerecord-migrations)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-migrations'
```

## Usage

Add something like this to `tasks/db.rake`

```ruby
require 'active_record/migrations/tasks'
# The root must be the root of your application, and contain `db/`.
ActiveRecord::Migrations.root = File.dirname(__dir__)
```

Somewhere else, ensure you have a suitable `environment` task, e.g:

```ruby
task :environment do
	# This must be a symbol... or establish_connection thinks it's a URL.
	DATABASE_ENV = :development
	
	ActiveRecord::Base.configurations = {
		# This key must be a string or it will not be matched by ActiveRecord:
		'development' => {
			# Using symbols for keys is fixed by this gem.
			adapter: 'sqlite3',
			database: 'db/development.db'
		}
	}
	
	# Connect to database:
	unless ActiveRecord::Base.connected?
		ActiveRecord::Base.establish_connection(DATABASE_ENV)
	end
end
```

### Deployment

This gem includes an additional task `db:deploy` which is designed to assist with deployment of sites with databases. When deploying a site for the first time, this task will create the database and load the seed data, then run any outstanding migrations. If deploying the site to an existing database it will simply run migrations.

The typical usage is to run `db:fixtures:update` which will generate all the required files into `db/fixtures/$DATABASE/`, which includes the contents of all tables and the current `schema.rb`.

### Fixtures

Fixtures are generated into `db/fixtures/$DATABASE_ENV/$TABLE_NAME.yml` by running `rake db:fixtures:dump`. You can limit this to specific tables by editing `db/fixtures/$DATABASE_ENV/tables.conf` which is loaded if present, or by specifying `TABLES=table1,table2` environment variable.

### Seed

This gem replaces the existing data seed mechanism with `db:fixtures:load`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## See Also

- [ActiveRecord::Rack](https://github.com/ioquatix/activerecord-rack)

## License

Released under the MIT license.

Copyright, 2016, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

