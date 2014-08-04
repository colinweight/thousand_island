module ThousandIsland
  module Components
    class Base

      attr_reader :pdf, :options

      def initialize(pdf, options={})
        @options = defaults.merge(options)
        @pdf = pdf
      end

      def draw(&block)
        if repeated?
          render_all &block
        else
          render &block
        end
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
        raise NotImplementedError
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
