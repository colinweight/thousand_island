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
        header_content if self.respond_to? :header_content
      end
    end

    def draw_body
      template.draw_body do
        body_content if respond_to? :body_content
      end
    end

    def draw_footer
      template.draw_footer do
        footer_content if respond_to? :footer_content
      end
    end

    def settings
      {}
    end

    def template
      @template ||= begin
        template = self.class.template_klass.new(settings)
        @pdf = template.pdf
        template
      end
    end

    #Respond to methods that relate to the style_sheet known styles
    def method_missing(method_name, *arguments, &block)
      if template.available_styles.include?(method_name)
        template.send(method_name, *arguments)
      else
        super
      end
    end

    def respond_to_missing?(method_name, *)
      template.available_styles.include?(method_name) || super
    end

  end
end