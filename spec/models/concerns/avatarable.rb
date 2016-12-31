shared_examples 'an avatarable record' do
  let(:klass) { subject.class }

  describe '#avatar' do
    context 'is invalid' do
      it 'when not a valid url' do
        expect(build klass, avatar: 'bananas').to be_invalid
      end
    end

    context 'is valid' do
      it 'when nil' do
        expect(build klass, avatar: nil).to be_valid
      end

      it 'when a valid url' do
        expect(build klass, avatar: 'http://google.com/image.png').to be_valid
      end
    end
  end
end
