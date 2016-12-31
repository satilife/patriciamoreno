require 'support/shared_contexts/omniauth'

RSpec.shared_examples 'an omniauth provider' do |provider_type, provider_label|
  describe 'omniauth provider' do
    include_context 'omniauth' do
      let(:provider)  { provider_type.to_s }
    end

    before { request.env['devise.mapping'] = Devise.mappings[:user] }

    context 'successful request' do
      let(:expected_message) { "Successfully authenticated from #{provider_label} account." }

      before { request.env['omniauth.auth'] = auth }

      context 'user does not exist' do
        it 'should create and sign in a new user' do
          get provider_type
          expect(response).to redirect_to root_path
          expect(subject.current_user).to_not be_nil
        end
      end

      context 'user is signed in' do
        before { sign_in user }
        let(:path) { edit_user_registration_path(user) }

        context 'with email matching incoming account' do
          let!(:user) { create :user, first_name: user_info.first_name, last_name: user_info.last_name, email: user_info.email }

          it 'should add the identity to the existing user' do
            get provider_type
            expect(response).to redirect_to path
            expect(subject.current_user).to eq user.reload
            expect(subject.current_user.identities.first.provider).to eq provider
          end
        end

        context 'with email different than incoming account' do
          let!(:user) { create :user, first_name: user_info.first_name, last_name: user_info.last_name, email: 'other@test.com' }

          it 'should add the identity to the existing user' do
            get provider_type
            expect(response).to redirect_to path
            expect(subject.current_user).to eq user.reload
            expect(subject.current_user.identities.first.provider).to eq provider
          end
        end
      end

      context 'user already exists' do
        let!(:user) { create :user, first_name: user_info.first_name, last_name: user_info.last_name, email: user_info.email }

        context 'without a provider identity' do
          it 'should create a new identity and sign in the existing user' do
            get provider_type
            expect(response).to redirect_to root_path
            expect(subject.current_user).to eq user.reload
            expect(subject.current_user.identities.first.provider).to eq provider
          end
        end

        context 'with an existing facebook identity' do
          let!(:identity) { create :identity, user: user, provider: provider, uid: uid }

          it 'should sign in the existing user' do
            get provider_type
            expect(response).to redirect_to root_path
            expect(subject.current_user).to eq user.reload
            expect(subject.current_user.identities.first).to eq identity
            expect(flash[:notice]).to eq expected_message
          end
        end
      end
    end

    context 'unsuccessful request' do
      let(:expected_message) { subject.send(:generic_error_message) }

      before do
        request.env['omniauth.error'] = 'some bad news'
        get provider_type
      end

      it 'should redirect with a flash error' do
        expect(response).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq expected_message
      end
    end
  end
end
