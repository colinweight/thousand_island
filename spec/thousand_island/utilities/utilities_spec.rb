module ThousandIsland
  module Utilities
    module DeepMerge

      describe TemplateOptions do


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

      describe TableOptions do

        let(:default) {{
          header_repeat: true,
          width: 600,
          cell_style: {
            borders: [:top, :bottom],
            border_width: 0.5,
            inline_format: true,
            size: 10
          },
          position: :center,
          header_format: {
            align: :center,
            font_style: :bold
          },
          footer_format: {
              font_style: :bold
          }
        }}
        let(:options) {{
          header_format: {
            align: :left,
          },
          header_repeat: false
        }}
        let(:over) {{
          header_format: {
            align: :right,
          },
          cell_style: {
            size: 12
          },
        }}

        it 'deep merges the hashes intelligently' do
          expected = {
            header_repeat: false,
            width: 600,
            cell_style: {
              borders: [:top, :bottom],
              border_width: 0.5,
              inline_format: true,
              size: 12
            },
            position: :center,
            header_format: {
              align: :right,
              font_style: :bold
            },
            footer_format: {
              font_style: :bold
            }
          }
          final = described_class.merge_options(over, options, default)
          expect(final).to eq(expected)
        end
      end
    end
  end
end