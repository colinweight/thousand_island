module ThousandIsland
  # The TableSettings class is where you set up styling rules that can be used by your Table class. You may create a class that inherits from TableSettings, and then use it in any of your tables. You can sub-class your TableStyles so you may define a master style for your app, but then have derived styles for special situations.
  #
  class TableSettings

    attr_reader :pdf, :overrides

    def initialize(pdf, overrides={})
      @pdf = pdf
      @overrides = overrides
    end

    #@TODO override this one!!! Do the docs...
    def table_settings
      {}
    end

    def settings
      deep_merger.merge_options(overrides, table_settings, default_options)
    end

    def default_options
      {
          width: pdf.bounds.width,
          cell_style: cell_styles,
          position: :center,
          header_format: header_format,
          header_repeat: true,
          footer_format: footer_format
      }
    end

    def cell_styles
      {
          borders: [:top, :bottom],
          border_width: 0.5,
          inline_format: true,
          size: 10
      }
    end

    def header_format
      {
          align: :center,
          font_style: :bold
      }

    end

    def footer_format
      {
          font_style: :bold
      }
    end

    private

    def deep_merger
      @deep_merger ||= Utilities::DeepMerge::TableOptions
    end

  end
end