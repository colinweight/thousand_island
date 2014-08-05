module ThousandIsland
  class Template

    attr_reader :pdf, :pdf_options

    class << self
      attr_writer :style_sheet_klass
      def style_sheet_klass
        @style_sheet_klass ||= ThousandIsland::StyleSheet
      end
    end

    def style_sheet
      @style_sheet ||= self.class.style_sheet_klass.new
    end

    def initialize(options={})
      setup_document_options(options)
      setup_prawn_document
    end

    def defaults
      {
        page_size: 'A4',
        page_layout: :portrait,
        left_margin: 54,
        right_margin: 54,
        top_margin: 56,
        bottom_margin: 80,
        header: {render: true},
        footer: {render: true},
      }
    end

    def draw_body(&block)
      body_content &block if respond_to? :body_content
    end

    def draw_header(&block)
      header_obj.draw do
        header_content &block if respond_to? :header_content
      end if pdf_options[:header][:render]
    end

    def draw_footer(&block)
      footer_obj.draw do
        footer_content &block if respond_to? :footer_content
      end if pdf_options[:footer][:render]
    end

    def setup_document_options(options={})
      @pdf_options = defaults.merge(options)
    end

    #Respond to methods that relate to the style_sheet known styles
    def method_missing(method_name, *arguments, &block)
      if style_sheet.available_styles.include?(method_name)
        style = style_sheet.send("#{method_name}_style")
        pdf.text *arguments, style
      elsif style_sheet.respond_to?("#{method_name.to_s}")
        style_sheet.send("#{method_name.to_s}")
      else
        super
      end
    end

    def respond_to_missing?(method_name, *)
      return true if style_sheet.available_styles.include?(method_name)
      style_sheet.respond_to?(method_name) || super
    end


  private
    def setup_prawn_document
      @pdf = Prawn::Document.new(pdf_options)
    end

    def header_obj
      @header ||= Components::Header.new(pdf, pdf_options[:header])
    end

    def footer_obj
      @footer ||= begin
        pdf_options[:footer][:style] = footer_style
        Components::Footer.new(pdf, pdf_options[:footer])
      end
    end

    def self.uses_style_sheet(klass)
      self.style_sheet_klass = klass
    end
  end
end
