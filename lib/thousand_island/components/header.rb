module ThousandIsland
  module Components
    class Header < Base
      
      def render
        document.bounding_box([0, document.bounds.height], width: document.bounds.width, height: options[:height]) do
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
          title: '',
          repeated: true
        }
      end
    end
  end
end
