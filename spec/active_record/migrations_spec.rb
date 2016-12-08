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

describe ActiveRecord::Migrations do
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
	
	it "should dump schema" do
		Dir.chdir(project_root) do
			system("rake", "db:schema:dump")
			
			expect(File).to be_exist("db/schema.rb")
		end
	end
end
