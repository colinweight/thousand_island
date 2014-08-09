module ThousandIsland
  # The Template class is where you can define elements that may be common to
  # all (or some) documents within your application. It is likely that a common
  # style will be required, so defining it in a Template and then using that
  # Template subclass in any custom Builders DRYs up your pdf generation, as
  # well as allowing for easy restyling across the whole application.
  #
  # Typically, the Template subclass would define the settings for the PrawnDocument,
  # as well as the settings for the header and footer. See the Docs below for the
  # <code>settings</code> method for the defaults. Add your own or override any
  # existing settings in the <code>settings</code> method. Any options passed into
  # the constructor as a Hash will be merged with these settings, and the defaults.
  #
  # Content for the header and footer will be defined in the methods
  # <code>header_content</code> and <code>footer_content</code>. These methods are
  # passed as a block when the pdf is rendered. Any standard Prawn methods may be
  # used (including bounding boxes or any other layout tools). In addition, any
  # of the styles from the <code>StyleSheet</code> can be applied as helper methods.
  # For instance, the default style sheet has a <code>h1_style</code> method that
  # returns a  ThousandIsland::StyleHash, so in your code you can use:
  #   h1 "My Document Header"
  # and Prawn will render the text in the style set in the <code>h1_style</code>
  # ThousandIsland::StyleHash.
  #
  # In addition to the supplied style methods, you can create a custom method:
  #   def magic_style
  #     ThousandIsland::StyleHash.new({
  #       size: 15
  #       style: bold
  #     })
  #   end
  # As long as the method ends in the word "_style" and returns a Hash, you magically
  # get to do this:
  #   magic "My magic text that is bold and size 15!!"
  # The method may return a standard Hash, but it is safer to return a
  # ThousandIsland::StyleHash, as this dynamically duplicates a few keys to accommodate
  # using the style in normal Prawn text methods as well as formatted text boxes, which
  # use a slightly different convention. You don't have to worry about that if you use
  # the ThousandIsland::StyleHash.
  #
  # Alternatively, your method could do this:
  #   def magic_style
  #     h1_style.merge({
  #       size: 15
  #       style: bold
  #     })
  #   end
  #
  # The following is an example of a custom template that subclasses
  # ThousandIsland::Template -
  #
  #   class MyTemplate < ThousandIsland::Template
  #     include MyCustomStyleSheet # optional
  #
  #     def settings
  #       {
  #         header: {
  #           height: 55,
  #           render:true,
  #         },
  #         footer: {
  #           render:true,
  #           height: 9,
  #           numbering_string: 'Page <page> of <total>'
  #         },
  #       }
  #     end
  #
  #     def header_content
  #       pdf.image "#{pdf_images_path}/company_logo.png", height: 30  # Standard Prawn syntax
  #     end
  #
  #     def footer_content
  #       footer "www.mycompanyurl.com"  # Using the magic method we get from the footer_style
  #     end
  #
  #     def pdf_images_path
  #       "#{Rails.root}/app/assets/pdf_images"  # This is entirely up to you
  #     end
  #   end
  #
  # Nb.
  # The Footer is a three column layout, with the numbering on the right column
  # and the content defined here in the middle. More flexibility will be added
  # in a later version.
  #
  # Optional:
  #
  # Add a <code>body_content</code> method to add content before whatever the
  # Builder defines in it's method of the same name.
  #
  class Template
    include ThousandIsland::StyleSheet

    attr_reader :pdf, :pdf_options

    def initialize(options={})
      setup_document_options(options)
      setup_prawn_document
      calculate_bounds
    end

    # Override in inheriting class to override defaults. The default settings
    # are:
    #   page_size: 'A4',
    #   page_layout: :portrait,
    #   left_margin: 54,
    #   right_margin: 54,
    #   header: {
    #     render: true,
    #     height: 33,
    #     bottom_padding: 20,
    #     repeated: true
    #   },
    #   footer: {
    #     render: true,
    #     height: 33,
    #     top_padding: 20,
    #     repeated: true,
    #     number_pages: true,
    #     numbering_string: '<page>',
    #     numbering_options: {
    #       align: :right,
    #       start_count_at: 1,
    #     }
    # The settings in the hash will be merged with the default settings. Any Prawn
    # setting <i>should</i> be valid at the top level of the hash.
    # The styles used in the Header and Footer are determined by the default styles in the
    # StyleSheet, but can be overridden in your Template class or by building your own StyleSheet
    def settings
      {}
    end

    def draw_body(&block)
      body_obj.draw do
        body_content if respond_to? :body_content
        yield if block_given?
      end
    end

    def draw_header
      header_obj.draw do
        header_content if respond_to? :header_content
        yield if block_given?
      end if render_header?
    end

    def draw_footer(&block)
      footer_obj.draw do
        yield if block_given?
        footer_content &block if respond_to? :footer_content
      end if render_footer?
    end

  private

    def render_header?
      pdf_options[:header][:render]
    end

    def render_footer?
      pdf_options[:footer][:render]
    end



    def calculate_bounds
      pdf_options[:body][:top] = body_start
      pdf_options[:body][:height] = body_height
    end

    def body_start
      @body_start ||= pdf.bounds.height - header_space
    end

    def body_height
      @body_height ||= body_start - footer_space
    end

    def header_space
      return (pdf_options[:header][:height] + pdf_options[:header][:bottom_padding]) if pdf_options[:header][:render]
      0
    end

    def footer_space
      return (pdf_options[:footer][:height] + pdf_options[:footer][:top_padding]) if pdf_options[:footer][:render]
      0
    end


    def setup_prawn_document
      @pdf = Prawn::Document.new(pdf_options)
    end

    def setup_document_options(options={})
      @pdf_options = deep_merger.merge_options(options, settings, defaults, component_defaults)
    end


    def component_defaults
      components = {
          footer: footer_klass.defaults,
          header: header_klass.defaults,
          body: body_klass.defaults,
      }
      components[:footer][:style] = footer_style
      components
    end

    def header_klass
      Components::Header
    end

    def header_obj
      @header ||= header_klass.new(pdf, pdf_options[:header])
    end

    def footer_klass
      Components::Footer
    end

    def footer_obj
      @footer ||= footer_klass.new(pdf, pdf_options[:footer])
    end

    def body_klass
      Components::Body
    end

    def body_obj
      @body ||= body_klass.new(pdf, pdf_options[:body])
    end



    def deep_merger
      @deep_merger ||= Utilities::DeepMerge
    end

    # Called by method missing when a style is supplied with text, ie: h1 'Header'
    def render_with_style(style, output)
      style_values = send("#{style}_style")
      pdf.text output, style_values
    end

    def defaults
      {
        page_size: 'A4',
        page_layout: :portrait,
        left_margin: 54,
        right_margin: 54,
        header: {
          render: true,
        },
        footer: {
          render: true,
        },
        body: {},
      }
    end

    #Respond to methods that relate to the style_sheet known styles
    def method_missing(method_name, *arguments, &block)
      style_method = "#{method_name}_style"
      if respond_to?(style_method)
        render_with_style(method_name, arguments[0])
      else
        super
      end
    end

    def respond_to_missing?(method_name, *)
      available_styles.include?(method_name) || super
    end

  end
end
