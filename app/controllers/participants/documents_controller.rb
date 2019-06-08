class Participants::DocumentsController < Participants::BaseController
  require "pdfkit"
  #
  def index
    @documents = Document.joins(:clients_documents, :users_documents)
                     .where(request_signature: true,
                            clients_documents: { client_id: current_client.id }).group(:id)
                     .where.not(id: UsersDocument.where(subscription: false)
                                        .pluck(:'users_documents.document_id'))
                     .page(params[:page]).per(10).search(params[:term])

    return unless @documents.empty?

    flash.now[:notice] = t('flash.actions.search.empty.m',
                           model: t('activerecord.models.document.one'))
  end

  def show
    @document = Document.find_by(id: params[:id])
  end

  def download
    @document = Document.find_by(id: params[:id])
    dc = @document.clients_documents.find_by(client_id: current_client.id)
    file = "#{Rails.root}/public/pdf/#{dc.key_code}.pdf"
    unless File.exists?(file)
      html = render_to_string(template: "participants/documents/show.html.erb", layout: false)
      kit = PDFKit.new(html, page_size: 'A4', dpi: 60)
      kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/participants/application.scss"
      kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/participants/documents.scss"
      pdf = kit.to_pdf
      kit.to_file(file)
    end
    if !pdf.nil?
      send_data pdf, filename: 'document.pdf', type: 'application/pdf'
    else
      send_data file, filename: 'document.pdf', type: 'application/pdf'
    end

  end

end
