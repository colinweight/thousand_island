module ThousandIsland
  describe Template do

    context 'setup' do
      it { expect(subject.pdf).to be_a(Prawn::Document) }

      it 'sets the options with merged defaults and passed options' do
        options = { op_one: 1, op_two: 2 }
        allow(subject).to receive(:defaults) { { op_two: 22, op_three: 3 } }
        subject.setup_document_options(options)
        expected = { op_one: 1, op_two: 2, op_three: 3 }
        expect(subject.pdf_options).to eq(expected)
      end

    end

    context 'Style Sheet' do
      it 'is the default' do
        expect(subject.style_sheet).to be_a(StyleSheet)
      end
      context 'adds method to template' do
        it 'h1' do
          expect(subject.respond_to?(:h1)).to be true
        end

        it 'h2' do
          expect(subject.respond_to?(:h2)).to be true
        end

        it 'h3' do
          expect(subject.respond_to?(:h3)).to be true
        end

        it 'h3_style' do
          expect(subject.respond_to?(:h3_style)).to be true
        end
      end

      it 'adds text to the pdf' do
        pdf = instance_double('Prawn::Document')
        allow(subject).to receive(:pdf) { pdf }
        expected = 'Test Text'
        style = subject.h1_style
        expect(pdf).to receive(:text).with(expected, style)
        subject.h1 expected
      end

      it 'does not add an h9 method' do
        expect(subject.respond_to?(:h9)).to be false
      end
    end

    context 'Header' do
      let(:header) { instance_double('ThousandIsland::Components::Header') }

      before :each do
        allow(header).to receive(:draw)
        allow(subject).to receive(:header_obj) { header }
      end

      it 'calls draw on the Header component' do
        expect(header).to receive(:draw)
        subject.draw_header
      end

      it 'does not call header_content if not exists' do
        expect(subject).to_not receive(:header_content)
        subject.draw_header
      end

      it 'calls header_content when it exists' do
        described_class.send(:define_method, :header_content) {}
        template = described_class.new
        expect(template).to receive(:header_content)
        template.draw_header
      end
    end

    context 'Footer' do
      let(:footer) { instance_double('ThousandIsland::Components::Footer') }

      before :each do
        allow(footer).to receive(:draw)
        allow(subject).to receive(:footer_obj) { footer }
      end

      it 'calls draw on the Footer component' do
        expect(footer).to receive(:draw)
        subject.draw_footer
      end

      it 'does not call footer_content if not exists' do
        expect(subject).to_not receive(:footer_content)
        subject.draw_footer
      end

      it 'calls footer_content when it exists' do
        described_class.send(:define_method, :footer_content) {}
        template = described_class.new
        expect(template).to receive(:footer_content)
        template.draw_footer
      end
    end

    context 'Body' do
      it 'does not call body if not exists' do
        expect(subject).to_not receive(:body_content)
        subject.draw_footer
      end

      it 'calls body when it exists' do
        described_class.send(:define_method, :body_content) {}
        template = described_class.new
        expect(template).to receive(:body_content)
        template.draw_body
      end
    end

  end
end
