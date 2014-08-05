module ThousandIsland
  describe Builder do

    context 'template method' do

      it 'instantiates a new instance of the template_class' do
        klass = described_class.dup
        template = double(:template)
        expect(template).to receive(:new).with({}) { template }
        expect(template).to receive(:pdf) {}
        klass.uses_template(template)
        klass.new.template
      end
    end

    context 'on build' do
      it 'raises with no template' do
        klass = described_class.dup
        builder = klass.new
        expect{ builder.build }.to raise_error(TemplateRequiredError)
      end

      context 'calls template method' do
        let(:template) { instance_double('ThousandIsland::Template') }
        let(:pdf) { instance_double('Prawn::Document') }
        let(:klass) { described_class.dup }
        let(:builder) { klass.new }

        before :each do
          allow(template).to receive(:draw_body) { template }
          allow(template).to receive(:draw_header) { template }
          allow(template).to receive(:draw_footer) { template }
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
      end
    end
  end
end