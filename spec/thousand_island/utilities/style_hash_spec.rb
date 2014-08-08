module ThousandIsland
  describe StyleHash do
    let(:opts) { {size: 1, style: 2, other: 3} }
    let(:subject) { described_class.new(opts) }

    it 'is a Hash' do
      expect(subject).to be_a(Hash)
    end

    it 'returns nil as default key' do
     expect(subject[:made_up_key]).to be nil
    end

    it 'sets the passed options' do
      expect(subject[:size]).to eq(1)
      expect(subject[:style]).to eq(2)
      expect(subject[:other]).to eq(3)
    end

    it 'gets size value for the font_size key' do
      expect(subject[:font_size]).to eq(1)
    end

    it 'gets style value for the styles key' do
      expect(subject[:styles]).to eq(2)
    end

  end
end
