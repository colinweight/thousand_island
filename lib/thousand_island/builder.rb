module ThousandIsland
  class Builder

    attr_reader :pdf

    class << self
      attr_writer :template_klass

      def template_klass
        raise TemplateRequiredError.new 'Builders must set a Template class with #uses_template in the Class body' if @template_klass.nil?
        @template_klass
      end

      def uses_template(klass)
        self.template_klass = klass
      end
    end


    def initialize(data={})
    end

    def filename
      'default_filename'
    end

    def build
      #body first so we know how many pages for repeated components
      draw_body
      draw_header
      draw_footer
      pdf.render
    end

    def draw_header
      template.draw_header do
        header if respond_to? :header
      end
    end

    def draw_body
      template.draw_body do
        body if respond_to? :body
      end
    end

    def draw_footer
      template.draw_footer do
        footer if respond_to? :footer
      end
    end

    def defaults
      {}
    end

    def template
      @template ||= begin
        template = self.class.template_klass.new(self.defaults)
        @pdf = template.pdf
        template
      end
    end

  end
end