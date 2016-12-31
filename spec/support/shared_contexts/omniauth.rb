RSpec.shared_context 'omniauth' do
  let(:provider)  { 'sample' }
  let(:uid)       { '12345' }
  let(:user_info) { OpenStruct.new({ first_name: 'Tony', last_name: 'Danza', email: 'tony@boss.com', image: 'http://img.com/1.png' }) }
  let(:auth)      { OpenStruct.new({provider: provider, uid: uid, info: user_info }) }
end
