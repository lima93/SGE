class AddSignatureDatetimeToUsersDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :users_documents, :signature_datetime, :datetime
  end
end
