module ThousandIsland
  describe Table do
    let(:pdf) { Prawn::Document.new({:page_size => "A4", :page_layout => :portrait}) }

    subject { described_class.new(pdf) }

    context 'when TableStyle is not set' do
      it 'sets default style' do
        expect(described_class.table_settings_klass).to eq(TableSettings)
      end
    end

    context 'when TableStyle is set' do
      it 'is used' do
        klass = described_class.dup
        Dummy = Class.new
        klass.uses_settings(Dummy)
        expect(klass.table_settings_klass).to eq(Dummy)
      end
    end

    describe '#header_rows' do
      it 'defaults to an empty array' do
        expect(subject.header_rows).to eq([])
      end

      it 'forces array' do
        expect{ subject.header_rows = 'not an array' }.to raise_error(ArgumentError)
      end

      it 'can be set with an array' do
        expect{ subject.header_rows = %w'it is an array' }.to_not raise_error
      end
    end

    describe '#body_rows' do
      it 'defaults to an empty array' do
        expect(subject.body_rows).to eq([])
      end

      it 'forces array' do
        expect{ subject.body_rows = 'not an array' }.to raise_error(ArgumentError)
      end

      it 'can be set with an array' do
        expect{ subject.body_rows = %w'it is an array' }.to_not raise_error
      end
    end

    describe '#footer_rows' do
      it 'defaults to an empty array' do
        expect(subject.footer_rows).to eq([])
      end

      it 'forces array' do
        expect{ subject.footer_rows = 'not an array' }.to raise_error(ArgumentError)
      end

      it 'can be set with an array' do
        expect{ subject.footer_rows = %w'it is an array' }.to_not raise_error
      end
    end

    describe 'header' do
      describe 'repeats' do
        let(:body_rows) { [] }
        let(:header_rows) { [[' ', { content: "Prefix", colspan: 2 } ], ['The Number', 'As', 'Bs'] ] }

        before do
          (1..50).each{ |n| body_rows.push( ["#{n}", "A#{n}", "B#{n}"] ) }
          subject.body_rows = body_rows
        end

        it 'all rows' do
          subject.header_rows = header_rows
          draw_the_table
          output = PDF::Inspector::Page.analyze(subject.pdf.render)
          expect(output.pages[0][:strings][0..4]).to eq(output.pages[1][:strings][0..4])
        end

        it 'unless specified not to' do
          subject.header_rows = header_rows
          draw_the_table({header_repeat: false})
          output = PDF::Inspector::Page.analyze(subject.pdf.render)
          expect(output.pages[0][:strings][0..4]).to_not eq(output.pages[1][:strings][0..4])
        end
      end
    end

    private

    def draw_the_table(opts={})
      subject.pdf.bounding_box( [0, std_doc_height], height: std_doc_height, width: std_doc_width ) do
        subject.draw(opts)
      end
    end

    def std_doc_height
      840
    end

    def std_doc_width
      595
    end

  end
end