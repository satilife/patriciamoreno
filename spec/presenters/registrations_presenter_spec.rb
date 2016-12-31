require 'rails_helper'

RSpec.describe RegistrationsPresenter, type: :presenter do
  let(:user)          { create :user }
  subject(:presenter) { RegistrationsPresenter.new(user, view) }

  describe '#show_password_change?' do
    context 'when the user has no password' do
      before { user.update(password_set: false) }

      context 'and some identities' do
        let!(:identity) { create :identity, user: user }

        it 'is false' do
          expect(subject.show_password_change?).to eq false
        end
      end

      context 'and no identities' do
        it 'is true' do
          expect(subject.show_password_change?).to eq true
        end
      end
    end

    context 'when the user has a password' do
      it 'is true' do
        expect(subject.show_password_change?).to eq true
      end
    end
  end

  describe '#facebook_row' do
    context 'when the user has no identities' do
      let(:html) { "<li class=\"list-group-item \">\n  <a class=\"btn btn-xs pull-right btn-success\" href=\"/users/auth/facebook\">Enable</a>\n  Login with Facebook\n</li>\n" }

      it 'allows identity to be created' do
        expect(subject.facebook_row).to eq html
      end
    end

    context 'when the user has identities' do
      let!(:identity) { create :identity, provider: 'facebook', user: user }

      let(:html) { "<li class=\"list-group-item list-group-item-success\">\n  <a class=\"btn btn-xs pull-right btn-danger\" data-confirm=\"Are you sure?\" rel=\"nofollow\" data-method=\"delete\" href=\"/identities/facebook\">Disable</a>\n  Login with Facebook\n</li>\n" }

      it 'allows identity to be destroyed' do
        expect(subject.facebook_row).to eq html
      end
    end
  end

  describe '#google_row' do
    context 'when the user has no identities' do
      let(:html) { "<li class=\"list-group-item \">\n  <a class=\"btn btn-xs pull-right btn-success\" href=\"/users/auth/google_oauth2\">Enable</a>\n  Login with Google\n</li>\n" }

      it 'allows identity to be created' do
        expect(subject.google_row).to eq html
      end
    end

    context 'when the user has identities' do
      let!(:identity) { create :identity, provider: 'google_oauth2', user: user }

      let(:html) { "<li class=\"list-group-item list-group-item-success\">\n  <a class=\"btn btn-xs pull-right btn-danger\" data-confirm=\"Are you sure?\" rel=\"nofollow\" data-method=\"delete\" href=\"/identities/google_oauth2\">Disable</a>\n  Login with Google\n</li>\n" }

      it 'allows identity to be destroyed' do
        expect(subject.google_row).to eq html
      end
    end
  end

end
