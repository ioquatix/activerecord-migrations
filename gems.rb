source 'https://rubygems.org'

# Specify your gem's dependencies in activerecord-migrations.gemspec
gemspec

group :development do
	gem "sqlite3"
	gem "mysql2"
end
