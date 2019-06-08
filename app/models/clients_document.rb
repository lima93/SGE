require 'json'
class ClientsDocument < ApplicationRecord
  belongs_to :client
  belongs_to :document

  validates :client_id, presence: true
  validate :json_input_field
  validates :client_id, uniqueness: { scope: :document }
  validates :key_code, uniqueness: true, on: :create

  def self.hash_fields(id)
    hash_field = to_hash_fields(id)
    activity_hash = []
    hash_field.each_index do |index, _hash|
      activity_hash[index] = hash_field[index].delete!('{}')
    end
    activity_hash = Hash[*[activity_hash.collect { |item| [item, ''] }].flatten]
    activity_hash
  end

  def self.csv_to(id)
    hash_field = to_hash_fields(id)
    hash_field.push(*'{cpf}')
    hash_field.each_index do |index, _hash|
      hash_field[index] = hash_field[index].delete!('{}')
    end
    CSV.generate(headers: true) do |csv|
      csv << hash_field
    end
  end

  def self.import(file, id)
    document = Document.find(id)
    if file.nil?
      return false
    else
      CSV.foreach(file.path, headers: true) do |row|
        cpf = row[row.length - 1].to_s
        client = Client.find_by(cpf: cpf)
        if client.nil?
          return false
        end
        hours_fields = row.to_hash
        hours_fields = hours_fields.without("cpf")
        document.clients_documents.create(client_id: client.id, document_id: document.id, participant_hours_fields: hours_fields)
        return true
      end
    end
  end

  private

  def self.to_hash_fields(id)
    d = Document.find_by(id: id)
    hash_fields = d.description.scan(/{\w[0-9a-zA-Z_]*}/)
    hash_fields.push(*d.activity.scan(/{\w[0-9a-zA-Z_]*}/))
    hash_fields.delete("{nome}")
    hash_fields.delete("{cpf}")
    hash_fields.delete_if { |k,_| /{assinatura_[0-9]*}/ ===  k }
    hash_fields
  end

  def json_input_field
    participant_hours_fields.each_value do |value|
      if value.blank?
        errors.add(:participant_hours_fields, 'Hora ' + I18n.t('errors.messages.blank'))
        break
      end
    end
  end
end
