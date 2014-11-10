module ThousandIsland
  module Components
    class Footer < Base

      def numbering_string
        options[:numbering_string]
      end

      def number_pages?
        options[:number_pages]
      end

      def render(&block)
        pdf.bounding_box([0, box_height], width: pdf.bounds.width, height: box_height) do
          col1
          col2(&block)
          # col3
        end
      end

      def after_render
        col3
      end

      def col1_width
        pdf.bounds.width * 0.15
      end

      def col2_width
        pdf.bounds.width * 0.7
      end

      def col3_width
        pdf.bounds.width * 0.15
      end

      def col1
      end

      def col2
        start = col1_width
        pdf.bounding_box([start, box_height], width: col2_width, height: box_height) do
          inject_style
          yield if block_given?
        end
      end

      def col3
        start = col1_width + col2_width
        pdf.bounding_box([start, box_height], width: col3_width, height: box_height) do
          pdf.number_pages numbering_string, numbering_options if number_pages?
        end
      end

      def box_height
        options[:height]
      end

      def numbering_options
        options[:style].merge(options[:numbering_options])
      end

      def repeated?
        options[:repeated]
      end

      def inject_style
        options[:style].each { |k,v| pdf.send(k, v) if pdf.respond_to?(k) } if options[:style]
      end

      def self.defaults
        {
          height: 33,
          top_padding: 20,
          repeated: true,
          numbering_options: default_numbering_options,
          number_pages: true,
          numbering_string: '<page>',
          style: {},
        }
      end

      def self.default_numbering_options
        {
          align: :right,
          start_count_at: 1,
        }
      end
    end
  end
end
