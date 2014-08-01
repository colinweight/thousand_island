module ThousandIsland
  module Components
    describe Header do
      let(:prawn_doc) { instance_double('Prawn::Document') }
      let(:bounds) { double(:bounds) }
      let(:header) { described_class.new(prawn_doc) }

      context 'interactions with Prawn' do

        before :each do
          allow(prawn_doc).to receive(:bounding_box).and_yield
          allow(bounds).to receive(:height) { std_doc_height }
          allow(bounds).to receive(:width) { std_doc_width }
          allow(prawn_doc).to receive(:bounds) { bounds }
        end

        context 'options' do
          context 'defaults' do
            it 'sizes the box' do
              h = header.options[:header_height]
              expect(prawn_doc).to receive(:bounding_box).with([0, std_doc_height], width: std_doc_width, height: h)
              header.render
            end
          end

          context 'custom' do
            let(:header) { described_class.new(prawn_doc, { header_height: 20 }) }

            it 'sizes the box' do
              expect(prawn_doc).to receive(:bounding_box).with([0, std_doc_height], width: std_doc_width, height: 20)
              header.render
            end
          end
        end
      end

    private
      def std_doc_height
        840
      end

      def std_doc_width
        595
      end

    end
  end
end