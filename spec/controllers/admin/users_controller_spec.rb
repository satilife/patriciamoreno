require 'rails_helper'
require 'support/shared_examples/crud_controller'

RSpec.describe Admin::UsersController, type: :controller do
  let(:klass)       { User }
  let(:params)      { { user: attributes_for(klass).merge({ password: nil, password_set: false }) } }
  let(:bad_params)  { { user: { email: 'wrong' } } }

  it_should_behave_like 'a crud controller'

  context 'password reset email' do
    let(:user)            { create :admin }
    let(:expected_notice) { 'Password reset email has been sent!' }

    before do
      sign_in user
      expect(controller).to receive(:set_record)
      controller.instance_variable_set(:@record, user)
      expect(user).to receive(:send_reset_password_instructions)
    end

    describe 'POST /reset_password' do
      before { request.env["HTTP_REFERER"] = 'http://test.com/foo' }

      it 'sends reset instructions' do
        post :reset_password, id: user.id
        expect(response).to redirect_to :back
        expect(flash[:notice]).to eq expected_notice
      end
    end

    describe 'POST /create' do
      let(:params)  { { user: attributes_for(klass).merge({ send_password_email: 1 }) } }
      let(:record)  { klass.last }

      it 'creates user and sends reset instructions' do
        post :create, params
        expect(response).to redirect_to(action: :show, id: record.id)
        expect(flash[:notice]).to eq expected_notice
      end
    end
  end
end
