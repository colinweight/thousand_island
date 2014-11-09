module ThousandIsland
  # The Table class can be used to set the definition of your table, such as
  # format and headings. You then inject the data from your Builder so that
  # it can be rendered.
  # You can declare a TableSettings class that you wish to use, otherwise
  # the default will be used. To set a Table Setting class, add the following
  # in your class body:
  #
  #   uses_style MyTableSettings
  #
  class Table

    attr_reader :pdf
    attr_accessor :table_options

    class << self
      attr_writer :table_settings_klass

      def table_settings_klass
        @table_settings_klass ||= TableSettings
      end

      def uses_settings(klass)
        self.table_settings_klass = klass
      end
    end

    def initialize(pdf)
      @pdf = pdf
      @table_options = {}
    end

    def settings
      {}
    end

    def draw(options={})

      @table_options = merged_options(options)

      table_options[:header] = prawn_header_setting

      pdf.table(table_data, options_for_prawn) do |t|
        t.row(0..num_header_rows - 1).font_style = table_options[:header_format][:font_style] unless header_rows.empty?
        t.row(0..num_header_rows - 1).align = table_options[:header_format][:align] unless header_rows.empty?
        t.row(-1..(0 - num_footer_rows)).font_style = :bold unless footer_rows.empty?
        yield(t) if block_given?
      end
    end

    def body_rows=(row_array)
      raise ArgumentError.new('table_rows must be an array') unless row_array.is_a?(Array)
      @body_rows = row_array
    end

    def body_rows
      @body_rows ||= []
    end

    def header_rows=(row_array)
      raise ArgumentError.new('header_cells must be an array') unless row_array.is_a?(Array)
      @header_rows = row_array
    end

    def header_rows
      @header_rows ||= []
    end

    def footer_rows=(row_array)
      raise ArgumentError.new('footer_rows must be an array') unless row_array.is_a?(Array)
      @footer_rows = row_array
    end

    def footer_rows
      @footer_rows ||= []
    end


    private

    def table_data
      data = body_rows
      header_rows.reverse_each{ |row| data.unshift(row) }
      footer_rows.each{ |row| data << row }
      data
    end

    def num_footer_rows
      footer_rows.size
    end

    def num_header_rows
      header_rows.size
    end


    def prawn_header_setting
      return false if header_rows.empty? || table_options[:header_repeat] == false
      header_rows.size
    end

    def options_for_prawn
      table_options.select{ |k| [:cell_style, :header, :column_widths, :position, :width, :row_colors, ].include?(k)}
    end

    def merged_options(options={})
      deep_merger.merge_options(options, settings, table_settings.settings)
    end

    def table_settings
      @table_settings||= self.class.table_settings_klass.new(pdf, settings)
    end

    def deep_merger
      @deep_merger ||= Utilities::DeepMerge::TableOptions
    end

  end
end