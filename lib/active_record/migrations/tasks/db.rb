# Copyright, 2016, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

namespace :db do
	task :load_config => :environment do
		database_tasks = ActiveRecord::Tasks::DatabaseTasks
		
		unless root = ActiveRecord::Migrations.root
			abort "ActiveRecord::Migrations.root needs to be set!"
		end
		
		unless DATABASE_ENV
			abort "DATABASE_ENV needs to be set!"
		end
		
		if ActiveRecord::Base.configurations.empty?
			abort "ActiveRecord::Base.configurations needs to be setup!"
		end
		
		database_tasks.root = root
		database_tasks.db_dir = File.join(root, 'db')
		database_tasks.env = DATABASE_ENV.to_s
		database_tasks.database_configuration = ActiveRecord::Base.configurations
		database_tasks.migrations_paths = File.join(root, 'db/migrate')
		database_tasks.fixtures_path = File.join(root, 'db/fixtures', DATABASE_ENV.to_s)
		
		database_tasks.send(:define_method, :load_seed) do
			load File.join(root, 'db/seed.rb')
		end
	end
	
	task 'Setup a new database if required and run migrations.'
	task :deploy => :load_config do
		database_tasks = ActiveRecord::Tasks::DatabaseTasks
		
		schema_path = File.join(database_tasks.db_dir, 'schema.rb')
		unless File.exist? schema_path
			abort "Missing #{schema_path}, cannot deploy!"
		end
		
		unless ActiveRecord::Migrations.database?
			Rake::Task['db:setup'].invoke
		end
		
		Rake::Task['db:migrate'].invoke
	end
	
	task :connection_config => :environment do
		require 'pp'
		
		pp ActiveRecord::Base.connection_config
	end
	
	task :connection_config => :environment do
		require 'pp'
		
		puts "Connection Configuration:"
		pp ActiveRecord::Base.connection_config
	end

	desc 'Print out connection configuration and available tables/data sources.'
	task :info => :connection_config do
		puts "Available Data Sources:"
		if ActiveRecord::Migrations.database?
			ActiveRecord::Base.connection.data_sources.each do |data_source|
				puts "\t#{data_source}"
			end
		else
			puts "\tDatabase does not exist."
		end
	end
end

# Loading this AFTER we define our own load_config task is critical, we need to make sure things are set up correctly before we run the task of the same name from ActiveRecord.
load 'active_record/railties/databases.rake'

# Now we work around some existing broken tasks:
Rake::Task['db:seed'].clear

namespace :db do
	desc 'Load the seed data into the database.'
	task :seed do
		ActiveRecord::Tasks::DatabaseTasks.load_seed
	end
end
