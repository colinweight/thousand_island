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

  end
end
