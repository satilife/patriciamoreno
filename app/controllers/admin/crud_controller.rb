class Admin::CrudController < AdminController
  before_action :set_records, only: :index
  before_action :set_record,  except: :index

  before_action :set_admin_details

  def render_crud
    render 'admin/shared/crud'
  end

  def handle_action
    if handle_callbacks
      handle_success
    else
      handle_error
    end
  end

  alias_method :index,   :render_crud
  alias_method :show,    :render_crud
  alias_method :new,     :render_crud
  alias_method :edit,    :render_crud
  alias_method :create,  :handle_action
  alias_method :update,  :handle_action
  alias_method :destroy, :handle_action

  private

  helper_method :confirm_delete_message,
                :breadcrumb_index_link,
                :breadcrumb_new_link, :breadcrumb_new_action,
                :breadcrumb_view_link, :breadcrumb_edit_action,
                :indexable?, :viewable?, :creatable?, :editable?, :deletable?,
                :index?, :new?, :create?, :show?, :edit?, :update?,
                :newish?, :editish?

  def breadcrumb_index_link; end

  def breadcrumb_new_link; end
  def breadcrumb_new_action
    @action
  end

  def breadcrumb_view_link; end
  def breadcrumb_edit_action
    @action
  end

  def confirm_delete_message
    'Are you sure? This cannot be undone!'
  end

  def handle_callbacks
    return false unless persist_changes
    return after_create != false if create?
    return after_update != false if update?
    after_destroy != false if destroy?
  end

  def after_create
    true
  end

  def after_update
    true
  end

  def after_destroy
    true
  end

  def indexable?
    true
  end

  def viewable?
    true
  end

  def creatable?
    true
  end

  def editable?
    true
  end

  def deletable?
    true
  end

  def newish?
    new? || create?
  end

  def editish?
    edit? || update?
  end

  def destroy?
    action_name == 'destroy'
  end

  def create?
    action_name == 'create'
  end

  def update?
    action_name == 'update'
  end

  def index?
    action_name == 'index'
  end

  def show?
    action_name == 'show'
  end

  def new?
    action_name == 'new'
  end

  def edit?
    action_name == 'edit'
  end

  def persist_changes
    case action_name
    when 'destroy'
      raise Exceptions::UndeletableRecord unless deletable?
      @record.destroy
    when 'new', 'create'
      handle_create
    when 'edit', 'update'
      handle_update
    end
  end

  def handle_create
    update_record_with_valid_params
  end

  def handle_update
    update_record_with_valid_params
  end

  def update_record_with_valid_params
    @record.update(valid_params) && @record.valid?
  end

  def handle_success
    flash[:notice] ||= "Request to #{action} the #{@record_type.singularize} was successful."

    if destroy?
      redirect_to after_destroy_path
    else
      redirect_to after_upsert_path
    end
  end

  def after_destroy_path
    @index_path
  end

  def after_upsert_path
    url_for(action: :show, id: @record.id)
  end

  def handle_error
    flash[:alert] ||= "Could not #{action} the #{@record_type}." unless @record.errors.any?
    render 'admin/shared/crud'
  end

  def error_action
    create? ? :new : :edit
  end

  def action
    params[:action].to_s
  end

  def set_record
    @record = params.key?(:id) ? record_scope.find(params[:id]) : model.new
  end

  def record_scope
    return model unless records_scope.present?
    model.send(records_scope)
  end

  def set_records
    @records = model.send(records_scope || :all).page(params[:page])
    return @records unless params.key?(:search)
    @records = @records.search(params[:search])
  end

  def records_scope; end

  def model
    @model ||= controller_name.singularize.camelize.constantize
  end

  def set_admin_details
    @title         = controller_name.titleize
    @action        = action_name.titleize
    @index_path    = url_for(action: :index)  if indexable?
    @new_path      = url_for(action: :new)    if creatable?
    @record_type   = @title.humanize.downcase
    @record_action = "#{@action} #{@record_type.singularize.titleize}"

    if @record.present? && @record.persisted?
      @show_path    = url_for(action: :show,    id: @record.id) if viewable?
      @edit_path    = url_for(action: :edit,    id: @record.id) if editable?
      @destroy_path = url_for(action: :destroy, id: @record.id) if deletable?
    end
  end
end
