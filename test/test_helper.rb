require "rubygems"
require "active_record"
require "bundler/setup"

Bundler.require :runtime, :development

require "acts_as_status_changeable"

DATABASE_NAME = "test/database.sqlite3"
DATABASE_PATH = File.expand_path(DATABASE_NAME)

class CreateStatusChangesTable < ActsAsStatusChangeable::Migration
end

class CreateGizmosTable < ActiveRecord::Migration
  def up
    create_table :gizmos do |t|
      t.string :status
      t.timestamps
    end
  end
end

def prepare_database
  delete_database

  SQLite3::Database.new(DATABASE_NAME)
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => DATABASE_NAME)

  CreateStatusChangesTable.new.up
  CreateGizmosTable.new.up
end

def delete_database
  File.delete(DATABASE_PATH) if File.exists?(DATABASE_PATH)
end

# At exit cleanup needs to be registered before requiring test/unit which uses the same technique.
at_exit { delete_database }
prepare_database

require "test/unit"

