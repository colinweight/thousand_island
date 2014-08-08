module ThousandIsland
  module Components
    describe Base do
      let(:prawn_doc) { instance_double('Prawn::Document') }
      let(:component) { described_class.new(prawn_doc) }
      let(:test_block) { lambda { |a| a } }

      it 'merges defaults and passed options on new' do
        options = { op_one: 1, op_two: 2 }
        component = described_class.new(prawn_doc, options)
        expected = component.defaults.merge(options)
        expect(component.options).to eq(expected)
      end

      context 'interactions with Prawn' do

        before :each do
          allow(prawn_doc).to receive(:bounding_box).and_yield
          allow(prawn_doc).to receive(:repeat).and_yield
        end

        it 'render all repeats the component' do
          allow(component).to receive(:render)
          expect(prawn_doc).to receive(:repeat).with(:all)
          component.render_all
        end

        context 'the block' do
          it 'yields when render' do
            expect{ |doc| component.render(&doc) }.to raise_error(NotImplementedError)
          end

          it 'is passed to render when render_all' do
            expect(component).to receive(:render)
            component.render_all(&test_block)
          end

          context 'is passed by draw to' do
            it 'render_all when repeated?' do
              allow(component).to receive(:repeated?) { true }
              expect(component).to receive(:render_all)
              component.draw(&test_block)
            end

            it 'render when not repeated?' do
              allow(component).to receive(:repeated?) { false }
              expect(component).to receive(:render)
              component.draw(&test_block)
            end
          end
        end
      end

      it 'raises on render' do
        expect{ component.render }.to raise_error(NotImplementedError)
      end

      it 'gets class defaults for instance' do
        expect(component.defaults).to eq(described_class.defaults)
      end

      it 'defaults to not repeated?' do
        expect(component.repeated?).to be false
      end

    end
  end
end