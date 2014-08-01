module ThousandIsland
  module Components
    class Base

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

      def render(&block)
        raise NotImplementedError
      end

      def repeated?
        raise NotImplementedError
      end

      def defaults
        {}
      end


    end
  end
end
