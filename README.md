# ActiveRecord::Migrations

This gem provides opinionated support for ActiveRecord migrations in non-Rails applications. It's faster and better defined than the competing gems, but only supports ActiveRecord 5+.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-migrations'
```

## Usage

Add something like this to `tasks/db.rake`

```ruby
task :environment do
	# This must be a symbol... or establish_connection thinks it's a URL.
	DATABASE_ENV = :development
	
	ActiveRecord::Base.configurations = {
		# This key must be a string or it will not be matched by ActiveRecord:
		'development' => {
			'adapter' => 'sqlite3',
			# This key must be a string or rake tasks will fail (e.g. each_current_configuration fails):
			'database' => 'db/development.db'
		}
	}
	
	# Connect to database:
	unless ActiveRecord::Base.connected?
		ActiveRecord::Base.establish_connection(DATABASE_ENV)
	end
end

require 'active_record/migrations'
ActiveRecord::Migrations.root = File.expand_path("../db", __dir__)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

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

