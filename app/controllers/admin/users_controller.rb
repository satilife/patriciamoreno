class Admin::UsersController < Admin::CrudController
  def reset_password
    send_password_reset
    redirect_to :back
  end

  private

  def subnav
    :users
  end

  def records_scope
    :for_listing
  end

  def deletable?
    !@record.admin?
  end

  def build_address
    @record.build_address unless @record.address.present?
  end

  def update_record_with_valid_params
    @record.update_without_password(valid_params) && @record.valid?
  end

  def handle_success
    send_password_reset if params.fetch(:user, {}).key?(:send_password_email)
    super
  end

  def send_password_reset
    @record.send_reset_password_instructions
    flash[:notice] = 'Password reset email has been sent!'
  end

  def valid_params
    params.require(:user).permit(allowed_parameters)
  end

  def allowed_parameters
    [ :first_name,
      :last_name,
      :email,
      :admin,
      :password,
      :password_set,
      :uploaded_avatar ]
  end
end
