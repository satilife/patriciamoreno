require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#active_for' do
    context 'when the controller name matches' do
      it 'returns "active"' do
        expect(helper.active_for('test')).to eq 'active'
      end
    end

    context 'when the controller name does not match' do
      it 'returns nil' do
        expect(helper.active_for('real')).to be_nil
      end
    end
  end
end
