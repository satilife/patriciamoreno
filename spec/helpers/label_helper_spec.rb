require 'rails_helper'

RSpec.describe LabelHelper, type: :helper do
  let(:yes_label_html) { "<span class=\"label label-success\">Yes</span>" }
  let(:no_label_html)  { "<span class=\"label label-danger\">No</span>" }
  let(:yes_inverse_label_html) { "<span class=\"label label-danger\">Yes</span>" }
  let(:no_inverse_label_html)  { "<span class=\"label label-success\">No</span>" }

  describe '#yes_label' do
    it 'returns a label' do
      expect(helper.yes_label).to eq yes_label_html
    end

    it 'returns an inverse label' do
      expect(helper.yes_label(true)).to eq yes_inverse_label_html
    end
  end

  describe '#no_label' do
    it 'returns a label' do
      expect(helper.no_label).to eq no_label_html
    end

    it 'returns an inverse label' do
      expect(helper.no_label(true)).to eq no_inverse_label_html
    end
  end

  describe '#yes_no_label' do
    it 'returns a label when true' do
      expect(helper.yes_no_label(true)).to eq yes_label_html
    end

    it 'returns a no label when false' do
      expect(helper.yes_no_label(false)).to eq no_label_html
    end

    it 'returns an inverse label when true' do
      expect(helper.yes_no_label(true, true)).to eq yes_inverse_label_html
    end

    it 'returns an inverse no label when false' do
      expect(helper.yes_no_label(false, true)).to eq no_inverse_label_html
    end
  end
end
