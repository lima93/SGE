class DocumentsController < ApplicationController

  def index; end

  def search
    send_file "#{Rails.root}/public/pdf/#{params[:code]}.pdf",
              filename: "documento.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end
end
