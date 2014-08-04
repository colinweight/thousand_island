module ThousandIsland
  module Components
    class Footer < Base
      
      def render
        document.bounding_box([0, 0], width: document.bounds.width, height: options[:height]) do
          yield if block_given?
        end
      end

      def repeated?
        options[:repeated]
      end

      def self.defaults
        {
          height: 33,
          top_padding: 20,
          repeated: true
        }
      end
    end
  end
end
