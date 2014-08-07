module ThousandIsland
  module Utilities

    describe DeepMerge do

      let(:default) {{
        header:{
          height: 33,
          repeated: true,
        },
        footer: {
          height: 33,
          repeated: true,
          numbering_options: {
            align: :right,
            start_count_at: 1,
          },
          number_pages: true,
          numbering_string: '<page>',
          style: {
            font_size: 23
          },
        },
      }}
      let(:options) {{
        header: {
            height: 33,
            repeated: false,
        },
        footer: {
          height: 40,
          repeated: true,
          numbering_options: {
            align: :right,
            start_count_at: 2,
          },
        },
      }}
      let(:over) {{
        header: {
          height: 50,
          repeated: true,
        },
        footer: {
          height: 50,
          repeated: false,
          numbering_options: {
            align: :left,
          },
          style: {
            font_size: 5
          },
        },
      }}

      it 'deep merges the hashes intelligently' do
        expected = {
          header: {
            height: 50,
            repeated: true,
          },
          footer: {
            height: 50,
            repeated: false,
            numbering_options: {
              align: :left,
              start_count_at: 2,
            },
            number_pages: true,
            numbering_string: '<page>',
            style: {
              font_size: 5
            },
          },
          body: {},
        }
        final = described_class.merge_options(over, options, default)
        expect(final).to eq(expected)
      end
    end
  end
end