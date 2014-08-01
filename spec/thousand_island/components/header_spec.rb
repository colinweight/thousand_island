module ThousandIsland
  module Components
    describe Header do
      let(:prawn_doc) { instance_double('Prawn::Document') }
      let(:header) { described_class.new(prawn_doc) }
      let(:bounds) { double(:bounds) }
      let(:test_block) { lambda { |a| a } }

      it '#repeated? uses the option value' do
        expect(header.repeated?).to eq(header.options[:repeated])
      end

      context 'interactions with Prawn' do

        before :each do
          allow(prawn_doc).to receive(:repeat) {  }
          allow(prawn_doc).to receive(:bounding_box).and_yield
          allow(prawn_doc).to receive(:repeat).and_yield
          allow(bounds).to receive(:height) { std_doc_height }
          allow(bounds).to receive(:width) { std_doc_width }
          allow(prawn_doc).to receive(:bounds) { bounds }
        end

        it 'repeats the header' do
          expect(prawn_doc).to receive(:repeat).with(:all)
          header.render_all
        end


        context 'the block' do
          it 'yields when render' do
            expect{ |doc| header.render(&doc) }.to yield_with_args(prawn_doc)
          end

          it 'is passed to render when render_all' do
            expect(header).to receive(:render)
            header.render_all(&test_block)
          end

          context 'is passed by draw to' do
            it 'render_all when repeated?' do
              allow(header).to receive(:repeated?) { true }
              expect(header).to receive(:render_all)
              header.draw(&test_block)
            end

            it 'render when not repeated?' do
              allow(header).to receive(:repeated?) { false }
              expect(header).to receive(:render)
              header.draw(&test_block)
            end
          end
        end

        context 'options' do
          context 'defaults' do
            it 'sizes the box' do
              header.render
              h = header.options[:header_height]
              expect(prawn_doc).to have_received(:bounding_box).with([0, std_doc_height], width: std_doc_width, height: h)
            end
          end
          context 'custom' do
            let(:header) { described_class.new(prawn_doc, { header_height: 20 }) }

            it 'sizes the box' do
              header.render
              expect(prawn_doc).to have_received(:bounding_box).with([0, std_doc_height], width: std_doc_width, height: 20)
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