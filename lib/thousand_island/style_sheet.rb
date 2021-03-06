module ThousandIsland
  # The StyleSheet is designed to be a mixin to the Template class. It may also
  # be included into other modules to define custom StyleSheets.
  #
  # Methods should return a StyleHash object rather than a vanilla Hash, as it
  # has some customisation to help it work with Prawn. The default_style is
  # used as the starting point for all other styles. For instance, the
  # <code>default_style[:size]</code> value is multiplied in the heading styles,
  # so changing the default style size value will have a cascading effect. Check
  # the source for the default values and override as preferred.
  #
  # An example of a custom StyleSheet:
  #
  #   module MyStyleSheet
  #     include ThousandIsland::StyleSheet
  #
  #     def default_style
  #       super.merge({
  #         size: 12,
  #         color: '222222'
  #       })
  #     end
  #
  #     def h1_style
  #       super.merge({ align: :center })
  #     end
  #
  #   end
  #
  module StyleSheet

    def default_style
      StyleHash.new({
          size: 10,
          style: :normal,
          align: :left,
          leading: 1,
          inline_format: true,
          color: '000000',
      })
    end

    def body_style
      default_style
    end

    def h1_style
      default_style.merge({
          size: default_style[:size] * 1.8,
          style: :bold,
          leading: 8,
      })
    end

    def h2_style
      default_style.merge({
          size: default_style[:size] * 1.5,
          style: :bold,
          leading: 4,
      })
    end

    def h3_style
      default_style.merge({
          size: default_style[:size] * 1.4,
          style: :bold,
          leading: 4,
      })
    end

    def h4_style
      default_style.merge({
          size: default_style[:size] * 1.1,
          style: :bold_italic,
          leading: 4,
      })
    end

    def h5_style
      default_style.merge({
          size: default_style[:size] * 1,
          leading: 4,
      })
    end

    def h6_style
      default_style.merge({
          size: default_style[:size] * 0.85,
          style: :italic,
          leading: 4,
      })
    end

    def footer_style
      default_style.merge({
         size: default_style[:size] * 0.8,
         color: '666666',
         align: :center,
      })
    end

  end
end
