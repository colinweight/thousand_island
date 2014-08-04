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

      it 'does not call self.header if not exists' do
        expect(subject).to_not receive(:header)
        subject.draw_header
      end

      it 'calls self header when it exists' do
        described_class.send(:define_method, :header) {}
        template = described_class.new
        expect(template).to receive(:header)
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

      it 'does not call self.footer if not exists' do
        expect(subject).to_not receive(:footer)
        subject.draw_footer
      end

      it 'calls self footer when it exists' do
        described_class.send(:define_method, :footer) {}
        template = described_class.new
        expect(template).to receive(:footer)
        template.draw_footer
      end
    end

    context 'Body' do
      it 'does not call self.body if not exists' do
        expect(subject).to_not receive(:body)
        subject.draw_footer
      end

      it 'calls self body when it exists' do
        described_class.send(:define_method, :body) {}
        template = described_class.new
        expect(template).to receive(:body)
        template.draw_body
      end
    end

  end
end
