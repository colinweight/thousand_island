module ThousandIsland
  class Builder

    attr_reader :pdf

    def initialize(data={})

    end

    def filename
      'default_filename'
    end

    def build
      raise TemplateRequiredError.new 'Your Builder must define a Template class' unless self.respond_to? :template
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

    def self.defaults
      {}
    end

    def defaults
      self.defaults
    end

    private
    def self.uses_template(template_class)
      define_method(:template) do
        template = instance_variable_get("@template")
        return template if template
        template = template_class.new(self.class.defaults)
        instance_variable_set("@template", template)
        instance_variable_set("@pdf", template.pdf)
        return template
      end
    end

  end
end