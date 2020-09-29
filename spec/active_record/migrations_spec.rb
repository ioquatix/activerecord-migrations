#!/usr/bin/env ruby

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

require 'active_record/migrations'
require 'fileutils'

RSpec.describe ActiveRecord::Migrations do
	let(:project_root) {File.expand_path("project", __dir__)}
	
	before(:each) do
		FileUtils.rm_rf Dir.glob(File.join(project_root, "db/migrate/*_create_employees*"))
		FileUtils.rm_rf File.join(project_root, "db/schema.rb")
		FileUtils.rm_rf File.join(project_root, "db/development.db")
	end
	
	it "should create and apply migration" do
		Dir.chdir(project_root) do
			system("rake", "db:migrations:new", "name=create_employees")
			
			expect(Dir.glob("db/migrate/*_create_employees.rb")).to_not be_empty
			
			system("rake", "db:migrate")
			
			expect(File.read("db/schema.rb")).to include("employees")
		end
	end
	
	it "should deploy schema and fixtures" do
		Dir.chdir(project_root) do
			# Ensure a valid database exists, and ca dump schema:
			system("rake", "db:deploy")
			
			expect(File).to be_exist("db/schema.rb")
			expect(File.read('db/schema.rb')).to include("version: 2016_12_08_121932")
		end
	end
	
	it "should handle non-existent configuration" do
		require 'active_record/migrations/tasks'
		ActiveRecord::Base.configurations = {
			"development" => "null://test",
		}
		expect do
			ActiveRecord::Tasks::DatabaseTasks.send(:each_current_configuration, "foo")
		end.to raise_error(ArgumentError, 'Cannot find configuration for environment "foo" in ["development"]')
	end
end
