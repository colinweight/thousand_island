module ThousandIsland
  describe Builder do

    context 'template' do

      it 'raises with no template' do
        klass = described_class.dup
        builder = klass.new
        expect{ builder.build }.to raise_error(TemplateRequiredError)
      end

      it 'method instantiates a new instance of the template_class' do
        klass = described_class.dup
        template = double(:template)
        allow(template).to receive(:available_styles) {[]}
        expect(template).to receive(:new).with({}) { template }
        expect(template).to receive(:pdf) {}
        klass.uses_template(template)
        klass.new.send(:template)
      end
    end

    context 'with instance' do

      describe 'content method is called when it' do
        let(:template) { ThousandIsland::Template.new }
        let(:klass) { described_class.dup }
        let(:builder) { klass.new }

        before :each do
          allow(builder).to receive(:template) { template }
        end
        context 'exists' do

          it 'header_content' do
            expect(builder).to receive(:header_content)
            builder.send(:draw_header)
          end
          it 'body_content' do
            expect(builder).to receive(:body_content)
            builder.send(:draw_body)
          end
          it 'footer_content' do
            expect(builder).to receive(:footer_content)
            builder.send(:draw_footer)
          end
        end
        context 'does not exist' do
          it 'header_content' do
            expect(builder).to_not respond_to(:header_content)
          end
          it 'body_content' do
            expect(builder).to_not respond_to(:body_content)
          end
          it 'footer_content' do
            expect(builder).to_not respond_to(:footer_content)
          end
        end
      end

      context 'calls template method' do
        let(:template) { ThousandIsland::Template.new }
        let(:pdf) { instance_double('Prawn::Document') }
        let(:klass) { described_class.dup }
        let(:builder) { klass.new }

        before :each do
          allow(template).to receive(:draw_body) { template }
          allow(template).to receive(:draw_header) { template }
          allow(template).to receive(:draw_footer) { template }
          allow(template).to receive(:available_styles) { [:h1] }
          allow(pdf).to receive(:render)
          allow(builder).to receive(:template) { template }
          allow(builder).to receive(:pdf) { pdf }
        end

        it '#draw_body' do
          expect(template).to receive(:draw_body)
          builder.build
        end

        it '#header' do
          expect(template).to receive(:draw_header)
          builder.build
        end

        it '#draw_footer' do
          expect(template).to receive(:draw_footer)
          builder.build
        end

        describe 'style methods' do
          it 'h1' do
            allow(template).to receive(:h1)
            expect(template).to receive(:available_styles)
            builder.h1 'text'
          end
        end
      end

      it 'table_with instantiates the class' do
        dummy_table = double
        expect(dummy_table).to receive(:new).with(subject.pdf)
        subject.table_with dummy_table
      end
    end
  end
end