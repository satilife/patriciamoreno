require 'rails_helper'
require 'support/shared_examples/omniauth_callbacks'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  it_should_behave_like 'an omniauth provider', :facebook,      'Facebook'
  it_should_behave_like 'an omniauth provider', :google_oauth2, 'Google'
end
