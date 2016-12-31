# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string           not null
#  uid        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  avatar     :string
#
# Indexes
#
#  index_identities_on_provider_and_uid  (provider,uid) UNIQUE
#  index_identities_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_5373344100  (user_id => users.id)
#

require 'rails_helper'
require 'models/concerns/avatarable'
require 'support/shared_contexts/omniauth'

RSpec.describe Identity, type: :model do
  let(:klass_symbol) { :user }
  subject(:identity) { create :identity }

  it_behaves_like 'an avatarable record'

  describe '#provider' do
    context 'when nil' do
      it 'is invalid' do
        expect(build :identity, provider: nil).to be_invalid
      end
    end

    context 'with a duplicate uid for provider' do
      it 'is invalid' do
        expect(build :identity, provider: identity.provider, uid: identity.uid).to be_invalid
      end
    end
  end

  describe '#uid' do
    context 'when nil' do
      it 'is invalid' do
        expect(build :identity, uid: nil).to be_invalid
      end
    end
  end

  describe '.from_omniauth' do
    let(:klass) { subject.class }
    include_context 'omniauth'

    context 'when identity already exists' do
      let!(:identity) { create :identity, provider: auth.provider, uid: auth.uid }

      it 'returns the existing identity' do
        expect(klass.from_omniauth(auth)).to eq identity
      end
    end

    context 'when identity does not exists' do
      it 'creates a new identity' do
        expect { klass.from_omniauth(auth) }.to change { klass.count }.by 1
      end
    end
  end
end
