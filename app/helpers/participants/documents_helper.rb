module Participants::DocumentsHelper
  def sub_hash_fields(document, column)
    hash = document.send(column).scan(/{\w[0-9a-zA-Z_]*}/)
    if hash.present?
      d = document.send(column)
      d = d.sub("{nome}", document.clients[document.client_ids.index(current_client.id)].name)
      d = d.sub("{cpf}", document.clients[document.client_ids.index(current_client.id)].cpf)
      hash.delete("{nome}")
      hash.delete("{cpf}")

      hash.each_index do |index|
        d = d.sub(hash[index].to_s, document.clients_documents[document.clients_documents.index { |x| x.client_id == current_client.id }].participant_hours_fields[hash[index].to_s.delete!('{}')])
      end
      d.delete!('{}')
    else
      document.send(column)
    end
  end

end
