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

class Identity < ActiveRecord::Base
  include Avatarable

  belongs_to :user

  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, scope: :provider

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |identity|
      identity.avatar = auth.info.image
    end
  end

  def label
    return 'Google' if provider == 'google_oauth2'

    provider.titleize
  end
end
