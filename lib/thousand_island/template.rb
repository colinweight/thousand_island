module ThousandIsland
  class Template

    attr_reader :doc, :doc_options

    def initialize(options={})
      setup_document_options(options)
      setup_prawn_document
    end

    def setup_prawn_document
      @doc = Prawn::Document.new(doc_options)
    end

    def setup_document_options(options={})
      @doc_options = document_defaults.merge(options)
    end

    def document_defaults
      {
        page_size: 'A4',
        page_layout: :portrait,
        left_margin: 54,
        right_margin: 54,
        top_margin: 56,
        bottom_margin: 80
      }
    end

    def header
      @header ||= Header.new(doc, doc_options)
    end

  end
end
