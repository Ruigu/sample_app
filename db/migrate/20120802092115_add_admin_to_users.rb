class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false 													#the argument default: false means that users will not be administrators by default
  end
end
