class AddKeyCodeToClientsDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :clients_documents, :key_code, :string
    add_index :clients_documents, :key_code, unique: true
  end
end
