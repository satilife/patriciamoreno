class IdentitiesController < ApplicationController
  before_action :set_identities,
                :validate_identities

  def destroy
    if @identities.destroy_all
      flash[:notice] = 'Removed external account from your soul.camp account.'
    else
      flash[:alert] = 'Oops! Something went wrong.'
    end

    redirect_to :back
  end

  private

  def set_identities
    @identities = current_user.identities.where(provider: params[:provider])
  end

  def validate_identities
    return if @identities.any?
    handle_error
  end

  def handle_success
    redirect_to :back
  end

  def handle_error
    flash[:alert] = 'Request invalid.'
    redirect_to :back
  end
end
