# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string           not null
#  last_name              :string           not null
#  email                  :string           not null
#  phone_number           :string
#  birthdate              :date
#  admin                  :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  password_set           :boolean          default(TRUE)
#  avatar                 :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_first_name            (first_name)
#  index_users_on_last_name             (last_name)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'
require 'models/concerns/authenticatable'
require 'models/concerns/avatarable'

RSpec.describe User, type: :model do
  let(:klass_symbol) { :user }
  subject(:user) { create :user, first_name: 'Test', last_name: 'User' }

  it_behaves_like 'an authenticatable record'
  it_behaves_like 'an avatarable record'

  describe '#first_name' do
    context 'when nil' do
      it 'is invalid' do
        expect(build :user, first_name: nil).to be_invalid
      end
    end
  end

  describe '#last_name' do
    context 'when nil' do
      it 'is invalid' do
        expect(build :user, last_name: nil).to be_invalid
      end
    end
  end

  describe '#email' do
    context 'when nil' do
      it 'is invalid' do
        expect(build :user, email: nil).to be_invalid
      end
    end

    context 'makes them lowercased' do
      let(:user) { create :user, email: 'Example@Email.com' }

      it 'downcases emails' do
        expect(user.email).to eq 'example@email.com'
      end
    end

    context 'when malformed' do
      it 'is invalid' do
        expect(build :user, email: 'email.com').to be_invalid
      end
    end

    context 'with a duplicate email' do
      it 'is invalid' do
        expect(build :user, email: subject.email).to be_invalid
      end
    end
  end

  describe '#initials' do
    it 'returns the expect value' do
      expect(subject.initials).to eq 'TU'
    end
  end

  describe '#name' do
    it 'returns the expect value' do
      expect(subject.name).to eq 'Test User'
    end
  end

  context 'admin and standard users' do
    let!(:non_admin) { user }
    let!(:admin)     { create :admin }

    describe '.admin' do
      it 'returns only users which are admins' do
        expect(User.admin).to eq [admin]
      end
    end

    describe '.standard' do
      it 'returns only non admin users' do
        expect(User.standard).to eq [non_admin]
      end
    end
  end
end
