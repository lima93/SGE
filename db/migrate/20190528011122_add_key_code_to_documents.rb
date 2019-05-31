class AddKeyCodeToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :key_code, :string
    add_index :documents, :key_code, unique: true
  end
end
