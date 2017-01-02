class AddUploadedAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :uploaded_avatar, :string
  end
end
