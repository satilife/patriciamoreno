class AddAvatar < ActiveRecord::Migration
  def change
    add_column :identities, :avatar, :string
    add_column :users, :avatar, :string
  end
end
