require 'rails_helper'

RSpec.describe FlashHelper, type: :helper do
  describe '#flash_message' do
    let(:notice) { 'This is a flash notice.' }
    let(:empty_notice) { nil }
    let(:page_specific_content) { "<a href='/foo/1'>Page specific link</a>" }
    let(:expected_partial) { 'shared/alert' }
    let(:custom_partial) { 'custom_template' }

    context 'with page specific' do
      before do
        view.content_for(:page_specific_notice) { page_specific_content.html_safe }
      end

      it 'renders page specific and flash notice' do
        expected_message = "#{notice} | #{page_specific_content}"
        expect(helper).to receive(:render).with(expected_partial, css_class: :info, message: expected_message)
        helper.flash_message(page_specific: :page_specific_notice, flash: notice, css_class: :info)
      end

      it 'renders page specific without flash notice' do
        expect(helper).to receive(:render).with(expected_partial, css_class: :info, message: page_specific_content)
        helper.flash_message(page_specific: :page_specific_notice, flash: empty_notice, css_class: :info)
      end
    end

    context 'without page specific' do
      it 'renders flash notice' do
        expect(helper).to receive(:render).with(expected_partial, css_class: :info, message: notice)
        helper.flash_message(page_specific: :empty_page_specific_notice, flash: notice, css_class: :info)
      end

      it 'renders flash notices with different templates' do
        expect(helper).to receive(:render).with(custom_partial, css_class: :info, message: notice)
        helper.flash_message(page_specific: :empty_page_specific_notice, flash: notice, css_class: :info, template: custom_partial)
      end
    end
  end
end
