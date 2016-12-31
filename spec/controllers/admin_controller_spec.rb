require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  describe '#authorize_admin!' do
    controller(AdminController) do
      # spec/support/views/admin/index.html exists to silence the missing template error
      def index; end
    end

    before do
      sign_in user
      get :index
    end

    context 'user is admin' do
      let(:user) { create :user, admin: true }

      it 'responds' do
        expect(response.status).to eq 200
        expect(response).to render_template 'layouts/admin'
      end
    end

    context 'user is NOT admin' do
      let(:user) { create :user }
      let(:unauthorized_message) { controller.send(:unauthorized_message) }

      it 'redirects' do
        expect(flash[:alert]).to eq unauthorized_message
        expect(response).to redirect_to root_path
      end
    end
  end
end
