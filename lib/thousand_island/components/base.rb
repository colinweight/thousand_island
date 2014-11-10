module ThousandIsland
  module Components
    class Base

      attr_reader :pdf, :options

      def initialize(pdf, args=nil)
        @options = args || self.defaults
        @pdf = pdf
      end

      def draw(&block)
        if repeated?
          render_all &block
        else
          render &block
        end
        after_render
      end

      def after_render
        nil
      end

      def render_all(&block)
        pdf.repeat :all do
          render &block
        end
      end

      def render(&block)
        raise NotImplementedError
      end

      def repeated?
        false
      end

      def self.defaults
        {}
      end

      def defaults
        self.class.defaults
      end
    end
  end
end
