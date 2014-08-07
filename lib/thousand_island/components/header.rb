module ThousandIsland
  module Components
    class Header < Base
      
      def render
        pdf.bounding_box([0, pdf.bounds.height], width: pdf.bounds.width, height: options[:height]) do
          yield if block_given?
        end
      end

      def repeated?
        options[:repeated]
      end

      def self.defaults
        {
          height: 33,
          bottom_padding: 20,
          repeated: true
        }
      end
    end
  end
end
