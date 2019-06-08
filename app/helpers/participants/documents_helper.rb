module Participants::DocumentsHelper
  def sub_hash_fields(document, column)
    hash = document.send(column).scan(/{\w[0-9a-zA-Z_]*}/)
    if hash.present?
      d = document.send(column)
      d = d.sub("{nome}", document.clients[document.client_ids.index(current_client.id)].name)
      d = d.sub("{cpf}", document.clients[document.client_ids.index(current_client.id)].cpf)
      hash.delete("{nome}")
      hash.delete("{cpf}")
      a = document.send(column).scan(/{assinatura_[0-9]*}/)
      a.each do |k|
        d = d.sub(k, '')
        hash.delete(k)
      end
      hash.each_index do |index|
        d = d.sub(hash[index].to_s, document.clients_documents[document.clients_documents.index { |x| x.client_id == current_client.id }].participant_hours_fields[hash[index].to_s.delete!('{}')])
      end
      d.delete!('{}')
    else
      document.send(column)
    end
  end

  def signature(document, column)
    unless document.send(column).nil?
      if column == 'description'
        a = document.send(column).scan(/{assinatura_[0-9]*}/)
        render partial: 'participants/documents/signature', locals: { signature: document, inital: 0, final: a.length }
      else
        ad = document.description.scan(/{assinatura_[0-9]*}/)
        a = document.send(column).scan(/{assinatura_[0-9]*}/)
        render partial: 'participants/documents/signature', locals: { signature: document, inital: ad.length, final: (a.length + ad.length) }
      end
    end
  end
end
