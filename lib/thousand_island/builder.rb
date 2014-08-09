module ThousandIsland
  # The Builder class is where the specific business logic for the pdf resides. Subclasses
  # of the ThousandIsland::Builder class may organise the data however they want to.
  # Subclasses are required to add a <code>uses_template <i>MyTemplateClass</i></code>
  # declaration in the Class body.
  #
  # Define a <code>filename</code> method that returns a string you might use to name
  # the file.
  #
  # The main body of the pdf document should be defined in a method called
  # <code>body_content</code>, that takes no arguments. Any values that need to be
  # accessed by the method should be declared as attributes are returned from other
  # methods (any method in the class has access to the <code>pdf</code> variable).
  # The <code>body_content</code> method is actually passed as a block behind the
  # scenes, to ensure it is rendered according to the <code>Template</code> and
  # <code>StyleSheet</code> settings.
  #
  # Call the <code>build</code> method on the instance, which will return the pdf
  # string as rendered by Prawn.
  #
  # The following is an example of a custom builder that subclasses
  # ThousandIsland::Builder -
  #
  #   class MyBuilder < ThousandIsland::Builder
  #     uses_template ThousandIsland::Template # or most likely a custom template
  #
  #     attr_reader :data
  #
  #     def initialize(data={})
  #       @data = data
  #       # do something with the data...
  #     end
  #
  #     def filename
  #       "Invoice Number #{data[:invoice].number}"
  #     end
  #
  #     def body_content
  #       # call custom methods that call methods on the pdf object (which is a Prawn::Document)
  #       # or call Prawn methods directly:
  #       pdf.text 'I can use this just like a raw Prawn'
  #
  #       # or use any of the style based helper methods
  #
  #       h4 'A sub heading'
  #       body 'Some text for the body of the pdf document'
  #     end
  #
  #   end
  #
  # Optional:
  #
  # Add a <code>header_content</code> method to add content below whatever is defined
  # in the Template. This will be repeated according to the header settings in the
  # Template.
  #
  # Add a <code>footer_content</code> method to add content above whatever is defined
  # in the Template. This will be repeated according to the footer settings in the
  # Template.
  #
  # Define a <code>settings</code> method that returns a Hash. This will be passed
  # to the Template class and will override any of the Template default settings.
  #
  #
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

    # Returns the finished pdf ready to save to the filesystem or send back to the user's browser
    def build
      #body first so we know how many pages for repeated components
      draw_body
      draw_header
      draw_footer
      pdf.render
    end

    def settings
      {}
    end

  private

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