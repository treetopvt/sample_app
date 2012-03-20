class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	add_index :users, :email, unique: true #:users defines the users datable, :email defines the field change
  end
end
