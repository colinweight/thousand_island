module ThousandIsland
  module Components
    describe Body do
      let(:prawn_doc) { instance_double('Prawn::Document') }
      let(:bounds) { double(:bounds) }
      let(:body) { described_class.new(prawn_doc) }

      context 'interactions with Prawn' do

        before :each do
          allow(prawn_doc).to receive(:bounding_box).and_yield
          allow(bounds).to receive(:height) { std_doc_height }
          allow(bounds).to receive(:width) { std_doc_width }
          allow(prawn_doc).to receive(:bounds) { bounds }
        end

        it 'sizes the box' do
          h = body.options[:height]
          t = body.options[:top]
          expect(prawn_doc).to receive(:bounding_box).with([0, t], width: std_doc_width, height: h)
          body.render
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