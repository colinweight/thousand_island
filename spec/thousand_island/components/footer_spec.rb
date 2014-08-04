module ThousandIsland
  module Components
    describe Footer do
      let(:prawn_doc) { instance_double('Prawn::Document') }
      let(:bounds) { double(:bounds) }
      let(:footer) { described_class.new(prawn_doc) }

      it '#repeated? uses the option value' do
        footer.options[:repeated] = true
        expect(footer.repeated?).to be true
      end

      context 'interactions with Prawn' do

        before :each do
          allow(prawn_doc).to receive(:bounding_box).and_yield
          allow(bounds).to receive(:height) { std_doc_height }
          allow(bounds).to receive(:width) { std_doc_width }
          allow(prawn_doc).to receive(:bounds) { bounds }
        end

        it 'sizes the box' do
          h = footer.options[:height]
          expect(prawn_doc).to receive(:bounding_box).with([0, 0], width: std_doc_width, height: h)
          footer.render
        end

      end

    private
      def std_doc_width
        595
      end

    end
  end
end