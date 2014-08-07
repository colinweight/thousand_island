module ThousandIsland
  describe StyleSheet do

    let(:expected_styles) {  [:h1, :h2, :h3, :h4, :h5, :h6, :body, :footer] }

    it 'builds the available styles array' do
      expect(subject.available_styles).to match_array(expected_styles)
    end

    it 'merges body_style with custom for h1' do
      expected = {
          size: 10 * 2.5,
          font_size: 10 * 2.5,
          style: :bold,
          styles: [:bold],
          align: :left,
          leading: 8,
          inline_format: true,
          color: '000000',
      }
      expect(subject.h1_style).to eq(expected)
    end

    it 'responds to h1_style' do
      expect(subject.respond_to?(:h1_style)).to be true
    end

    it 'responds to h2_style' do
      expect(subject.respond_to?(:h2_style)).to be true
    end

    it 'responds to h3_style' do
      expect(subject.respond_to?(:h3_style)).to be true
    end

  end
end