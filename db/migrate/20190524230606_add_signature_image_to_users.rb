class AddSignatureImageToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :signature_image, :string
  end
end
