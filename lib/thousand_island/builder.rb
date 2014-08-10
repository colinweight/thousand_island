module ThousandIsland
  # Your Builder class is where you will put the necessary logic for
  # rendering the final pdf. It's up to you how you get the data into
  # the Builder. It will depend on the complexity. You might just pass
  # an Invoice object (<code>MyBuilder.new(invoice))</code>) or you may have a
  # bunch of methods that are called by an external object to get the
  # data where it needs to be.
  #
  # You must declare which Template class you will be using. Failing
  # to do so will raise a <code>TemplateRequiredError</code> when you call the
  # build method. Declare the template with the following in the main
  # class body:
  #
  #   uses_template MyTemplate
  #
  # Your Builder can have a <code>filename</code> method, which will help a Rails
  # Controller or other class determine the name to use to send the
  # file to the browser or save to the filesystem (or both). Without
  # this method it will have a default name, so you may choose to put
  # the naming logic for your file elsewhere, it's up to you.
  #
  # You must have a <code>body_content</code> method that takes no arguments (or
  # the pdf will be empty!). This is the method that is passed around
  # internally in order for Prawn to render what is in the method.
  # You can use raw Prawn syntax, or any of the style magic methods
  # to render to the pdf. You may also call other methods from your
  # <code>body_content</code> method, and use Prawn syntax and magic methods in
  # those too.
  #
  #  A Builder example might be:
  #
  #   class MyBuilder < ThousandIsland::Builder
  #     uses_template MyTemplate
  #
  #     attr_reader :data
  #
  #     def initialize(data={})
  #       @data = data
  #       # do something with the data...
  #     end
  #
  #     def filename
  #       "Document#{data.id_number}"
  #     end
  #
  #     def body_content
  #       # call custom methods, magic methods or call Prawn methods directly:
  #       h1 'Main Heading'
  #       display_info
  #       body 'Main text in here...'
  #     end
  #
  #     # Custom method called by body_content
  #     def display_info
  #       body "Written by: #{data.author}"
  #       pdf.image data.avatar, height: 20
  #     end
  #   end
  #
  #
  # Finally, to get the finished pdf from your Builder, call the <code>build</code> method like so:
  #
  #   pdf = my_builder.build
  #
  #
  # Optional:
  #
  # Define a <code>header_content</code> method to add content below whatever is defined in the Template. This will be repeated according to the header settings in the Template.
  #
  # Define a <code>footer_content</code> method to add content above whatever is defined in the Template. This will be repeated according to the footer settings in the Template.
  #
  # Define a <code>settings</code> method that returns a Hash. This will be passed to the Template class and will override any of the Template default settings.
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

    def initialize(data=nil)
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