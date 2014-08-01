module ThousandIsland
  module Components
    class Header < Base
      
      def render
        document.bounding_box([0, document.bounds.height], width: document.bounds.width, height: options[:header_height]) do
          yield(document) if block_given?
        end
      end

      def repeated?
        options[:header_repeated]
      end

      def defaults
        {
          header_height: 33,
          header_bottom_padding: 20,
          title: '',
          header_repeated: true
        }
      end
    end
  end
end
