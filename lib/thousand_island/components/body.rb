module ThousandIsland
  module Components
    class Body < Base
      
      def render
        start_coords = [0, options[:top]]
        pdf.bounding_box(start_coords, height: options[:height], width: pdf.bounds.width) do
          yield if block_given?
        end
      end

      def self.defaults
        {
        }
      end
    end
  end
end
