module ThousandIsland
  module Components
    class Header

      attr_reader :document, :options

      def initialize(document, options={})
        @options = defaults.merge(options)
        @document = document
      end

      def draw(&block)
        if repeated?
          render_all &block
        else
          render &block
        end
      end

      def render_all(&block)
        document.repeat :all do
          render &block
        end
      end

      def render
        document.bounding_box([0, document.bounds.height], width: document.bounds.width, height: options[:header_height]) do
          yield(document) if block_given?
        end
      end

      def repeated?
        options[:repeated]
      end

      def defaults
        {
          header_height: 33,
          header_bottom_padding: 20,
          title: '',
          repeated: true
        }
      end


    end
  end
end
