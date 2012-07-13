class CreateUsers < ActiveRecord::Migration
  def change								#change method that determines the change to be made to the database
    create_table :users do |t|				#rails method to create a table with a block |t| for "table"
      t.string :name						#table column with type string
      t.string :email

      t.timestamps							#command that creates two magic columns "created_at" and "updated_at" which are timestamps that automatically record when a user is created and updated
    end
  end
end
