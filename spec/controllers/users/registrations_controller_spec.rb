require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:user) { create :user }

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe 'PUT /registrations' do
    before { put :update, user: params }

    context 'update user info' do
      let(:params) { { first_name: 'Joe', last_name: 'Swanson', email: 'joe@swanson.com', phone_number: '+18608675309' } }

      it 'allows for the updating of all "soft" params without a password' do
        user.reload
        params.each do |k, v|
          expect(user.public_send(k)).to eq v
        end
      end
    end

    context 'update password' do
      let(:params)  { { password: 'soulcamp', password_confirmation: 'soulcamp' } }

      context 'when no password has been set' do
        before { user.update(password_set: false) }

        it 'allows the user to update their password without sending their current' do
          expect(response.status).to eq 200
        end
      end

      context 'when a password has been set' do
        let(:resource) { subject.send(:resource) }

        it 'requires the user to send their current password' do
          expect(resource.errors.any?).to be true
        end
      end
    end
  end
end
