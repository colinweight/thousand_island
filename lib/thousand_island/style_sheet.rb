module ThousandIsland
  class StyleSheet

    def self.known_styles
      [:default, :h1, :h2, :h3, :h4, :h5, :h6]
    end

    #Create a method for each of the known styles that returns the hash
    known_styles.each do |style|
      style_method_name = "#{style.to_s}_style"
      defaults_method_name = "#{style.to_s}_defaults"
      define_method(style_method_name.to_sym) do
        method(defaults_method_name.to_sym).()
      end
    end

    def known_styles
      self.class.known_styles
    end

    def defaults
      {
          size: 10,
          style: :normal,
          align: :left,
          leading: 1,
          inline_format: true,
          color: '000000',
      }
    end

    def h1_defaults
      defaults.merge({
          size: defaults[:size] * 2.5,
          style: :bold,
          leading: 8,
      })
    end

    def h2_defaults
      defaults.merge({
          size: defaults[:size] * 2.14,
          style: :bold,
          leading: 2,
      })
    end

    def h3_defaults
      defaults.merge({
          size: defaults[:size] * 1.7,
          style: :bold,
      })
    end

    def h4_defaults
      defaults.merge({
          size: defaults[:size] * 1.3,
          style: :bold_italic,
      })
    end

    def h5_defaults
      defaults.merge({
          size: defaults[:size] * 1,
      })
    end

    def h6_defaults
      defaults.merge({
          size: defaults[:size] * 0.85,
          style: :italic,
      })
    end

  end
end