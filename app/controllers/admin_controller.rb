class AdminController < ApplicationController
  before_action :authenticate_user!,
                :authorize_admin

  layout 'admin'

  private

  def admin?
    true
  end

  def authorize_admin
    redirect_to(root_path, alert: unauthorized_message) unless current_user.admin?
  end

  def unauthorized_message
    'You are not authorized to view this page.'
  end
end
