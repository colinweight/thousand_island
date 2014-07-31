module ThousandIsland
  describe Document do
    context 'setup' do
      it { expect(subject.doc).to be_a(Prawn::Document) }

      it 'sets the options with merged defaults and passed options' do
        options = { op_one: 1, op_two: 2 }
        merged = { op_one: 1, op_two: 2, op_three: 3 }
        allow(subject).to receive(:document_defaults) { { op_two: 22, op_three: 3 } }
        subject.setup_document_options(options)
        expect(subject.doc_options).to eq(merged)
      end
    end

  end
end
