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

FactoryGirl.define do
  factory :identity do
    user
    provider  { Faker::App.name }
    uid       { Faker::Company.swedish_organisation_number }
  end
end
