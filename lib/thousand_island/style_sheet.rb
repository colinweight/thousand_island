module ThousandIsland
  class StyleSheet

    class << self
      attr_writer :available_styles

      def available_styles
        @available_styles ||= []
      end
    end

    def available_styles
      self.class.available_styles
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

    def body_defaults
      defaults
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

    def footer_defaults
      defaults.merge({
         size: defaults[:size] * 0.8,
         color: '666666',
         align: :center,
     })
    end

    def default_style
      defaults.merge({
        font_size: defaults[:size],
        styles: [defaults[:style]],
      })
    end


    #Create a method for each of the known styles from the defaults
    instance_methods.grep(/_defaults$/).each do |method_name|
      method_name = method_name.to_s
      style = method_name.sub('_defaults', '')
      available_styles << style.to_sym
      style_method_name = "#{style}_style"
      define_method(style_method_name) do
        defaults = method(method_name).()
        new_keys = {
            font_size: defaults[:size],
            styles: [defaults[:style]],
        }
        defaults.merge(new_keys)
      end
    end

  end
end