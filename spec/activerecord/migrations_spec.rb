
require 'activerecord/migrations'
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
