module ThousandIsland
  class Template

    attr_reader :pdf, :pdf_options

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
      body &block if respond_to? :body
    end

    def draw_header(&block)
      header_obj.draw do
        header &block if respond_to? :header
      end if pdf_options[:header][:render]
    end

    def draw_footer(&block)
      footer_obj.draw do
        footer &block if respond_to? :footer
      end if pdf_options[:footer][:render]
    end

    def setup_document_options(options={})
      @pdf_options = defaults.merge(options)
    end

  private
    def setup_prawn_document
      @pdf = Prawn::Document.new(pdf_options)
    end

    def header_obj
      @header ||= Components::Header.new(pdf, pdf_options[:header])
    end

    def footer_obj
      @footer ||= Components::Footer.new(pdf, pdf_options[:footer])
    end

  end
end
