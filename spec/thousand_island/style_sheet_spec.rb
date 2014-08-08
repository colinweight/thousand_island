module ThousandIsland
  describe StyleSheet do
    let(:subject) do
      dummy = Class.new
      dummy.include(described_class)
      dummy.new
    end
    let(:expected_styles) {  [:h1, :h2, :h3, :h4, :h5, :h6, :body, :footer] }

    it 'builds the available styles array' do
      expect(subject.available_styles).to match_array(expected_styles)
    end

    it 'has a style method for every style' do
      expected_styles.each do |s|
        expect(subject.send("#{s}_style")).to be_a(StyleHash)
      end
    end

    it 'merges body_style with custom for h1' do
      expected = {
          size: 10 * 2.5,
          style: :bold,
          align: :left,
          leading: 8,
          inline_format: true,
          color: '000000',
      }
      expect(subject.h1_style).to eq(expected)
    end

    context 'extends the Hash with' do
      it 'font_size' do
        style = subject.h1_style
        expect(style[:font_size]).to eq(style[:size])
      end
      it 'styles' do
        style = subject.h3_style
        expect(style[:styles]).to eq(style[:style])
      end
    end

  end
end