require 'support/shared_contexts/omniauth'

RSpec.shared_examples 'an authenticatable record' do
  include_context 'omniauth'

  let(:klass)           { subject.class }
  let(:oauth_record)    { create klass, first_name: user_info.first_name, last_name: user_info.last_name, email: user_info.email }

  describe '.from_omniauth' do
    let(:instance)  { klass.from_omniauth(auth) }

    context 'when no instance exists' do
      it 'creates an instance with an identity' do
        expect { instance }.to change { klass.count }.by 1
        expect(instance.identities.first.provider).to eq provider
        expect(klass.last.password_set).to eq false
      end
    end

    context 'when an instance exists' do
      let!(:record) { oauth_record }

      context 'but no identity exists' do
        it 'creates a new identity and returns the instance' do
          expect { instance }.to change { Identity.count }.by 1
          expect(instance).to eq record
          expect(instance.password_set).to eq true
        end
      end

      context 'and an identity exists' do
        let!(:identity) { record.identities.create(provider: provider, uid: uid) }

        it 'just returns the instance' do
          expect { instance }.to_not change { Identity.count }
          expect(instance.identities.first).to eq identity
        end
      end
    end
  end

  describe '#add_omniauth' do
    let!(:record)   { oauth_record }
    let(:instance)  { record.add_omniauth(auth) }

    context 'with no current identities' do
      it 'creates a new identity and returns the instance' do
        expect { instance }.to change { Identity.count }.by 1
        expect(instance.user).to eq record
      end
    end

    context 'which already exists' do
      let!(:identity) { record.identities.create(provider: provider, uid: uid) }

      it 'returns the identity' do
        expect { instance }.to_not change { Identity.count }
        expect(instance).to eq identity
      end
    end

    context 'with a different identity email' do
      before do
        record.update(email: 'other@email.com')
      end

      it 'creates a new identity for the user' do
        expect { instance }.to change { Identity.count }.by 1
        expect(instance.user).to eq record
      end
    end

    context 'with an identity that matches another user' do
      let!(:identity) { instance }
      let!(:other)    { create klass }

      it 'raises an error' do
        expect { other.add_omniauth(auth) }.to raise_error Exceptions::IdentityExistsError
      end
    end
  end

  describe '#update_with_first_password' do
    let(:params) { { password: 'soulcamp', password_confirmation: 'soulcamp' } }

    context 'when no password has been set' do
      before { subject.update(password_set: false) }

      context 'with valid params' do
        it 'allows the password to be saved without the :current_password' do
          expect { subject.update_with_first_password(params) }.to change { subject.encrypted_password }
          expect(subject.password).to be_blank
          expect(subject.password_confirmation).to be_blank
        end
      end

      context 'without valid params' do
        before { params[:password_confirmation] = 'bad' }

        it 'raises an error' do
          expect { subject.update_with_first_password(params) }.to raise_error ActiveRecord::RecordInvalid
        end
      end
    end

    context 'when a password has already been set' do
      it 'raises an error' do
        expect { subject.update_with_first_password(params) }.to raise_error Exceptions::PasswordAlreadySetError
      end
    end
  end
end
