class AddGroupNameToComments < ActiveRecord::Migration
  def change
    add_column :comments, :group_name, :string, default: ''
  end
end
