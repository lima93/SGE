class AddOwnersToUsersDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :users_documents, :owner, :boolean, default: false
  end
end
