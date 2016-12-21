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
	namespace :fixtures do
		task :fixtures_path => :load_config do
			@fixtures_path = ENV.fetch('FIXTURES_PATH') {ActiveRecord::Tasks::DatabaseTasks.fixtures_path}
			@tables_path = File.join(@fixtures_path, 'tables.conf')
		end
		
		desc 'List the tables to be dumped, either via `ENV[\'TABLES\']` or `tables.conf`.'
		task :tables => :fixtures_path do
			all_tables = ActiveRecord::Base.connection.tables
			
			if tables_string = ENV['TABLES']
				@tables = tables_string.split(',')
			elsif File.exist?(@tables_path)
				puts "Loading tables from: #{@tables_path}"
				@tables = YAML::load_file(@tables_path)
			else
				# We skip update/event tables since these contain a lot of non-critical data.
				@tables = all_tables.grep_v(/ar_internal_metadata/)
			end
			
			puts "Dumping tables: #{@tables.join(', ')}"
			puts "Skipping tables: #{(all_tables - @tables).join(', ')}"
		end
		
		desc 'Copy the current schema to the fixtures schema.'
		task :copy_schema => :fixtures_path do
			database_tasks = ActiveRecord::Tasks::DatabaseTasks
			
			fixtures_schema_path = File.join(database_tasks.fixtures_path, 'schema.rb')
			db_schema_path = File.join(database_tasks.db_dir, 'schema.rb')
			
			FileUtils.cp(db_schema_path, fixtures_schema_path)
		end
		
		desc 'Create YAML fixtures from data in an existing database.'
		task :dump => :tables do
			sql = "SELECT * FROM %s"
			
			FileUtils.mkpath @fixtures_path
			
			@tables.each do |table_name|
				# It's with regret that we have to use .yml here, as that's the only extension supported by ActiveRecord db:fixtures:load
				fixture_path = "#{@fixtures_path}/#{table_name}.yml"
				
				puts "Dumping #{table_name} to #{fixture_path}..."
				
				i = "000"
				
				File.open(fixture_path, 'w') do |file|
					rows = ActiveRecord::Base.connection.select_all(sql % table_name)
					
					records = rows.each_with_object({}) do |row, hash|
						hash["#{table_name}_#{i.succ!}"] = row
					end
					
					file.write records.to_yaml
				end
			end
		end
		
		desc 'Update the fixtures and copy the schema.'
		task :update => [:copy_schema, :dump] do
			unless File.exist? @tables_path
				File.write(@tables_path, YAML::dump(@tables))
			end
		end
	end
end
