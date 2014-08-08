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

      context 'Page Numbering' do
        context 'uses the correct string when options are' do
          it 'set' do
            expected = 'Page <page> of <total>'
            footer.options[:numbering_string] = expected
            expect(footer.numbering_string).to eq(expected)
          end

          it 'not set' do
            expect(footer.numbering_string).to eq('<page>')
          end
        end

      end

      context 'interactions with Prawn' do

        before :each do
          allow(prawn_doc).to receive(:bounding_box).and_yield
          allow(bounds).to receive(:width) { std_doc_width }
          allow(prawn_doc).to receive(:bounds) { bounds }
          allow(prawn_doc).to receive(:number_pages)
        end

        it 'sizes the box' do
          h = footer.options[:height]
          expect(prawn_doc).to receive(:bounding_box).with([0, h], width: std_doc_width, height: h)
          footer.render
        end

        it 'renders the page numbers' do
          expect(prawn_doc).to receive(:number_pages).with(footer.numbering_string, footer.options[:numbering_options])
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