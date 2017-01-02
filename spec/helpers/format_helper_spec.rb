require 'rails_helper'

RSpec.describe FormatHelper, type: :helper do
  describe '#format_date' do
    it 'formats the date' do
      expect(helper.format_date(Date.today)).to eq Date.today.to_formatted_s(:long)
    end
  end

  describe '#format_datetime' do
    it 'formats the time' do
      expect(helper.format_datetime(Time.now)).to eq Time.now.localtime.to_formatted_s(:long)
    end
  end
end
