class Participants::DocumentsController < Participants::BaseController

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
end
