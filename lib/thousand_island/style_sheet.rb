module ThousandIsland
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
          size: default_style[:size] * 2.5,
          style: :bold,
          leading: 8,
      })
    end

    def h2_style
      default_style.merge({
          size: default_style[:size] * 2.14,
          style: :bold,
          leading: 2,
      })
    end

    def h3_style
      default_style.merge({
          size: default_style[:size] * 1.7,
          style: :bold,
      })
    end

    def h4_style
      default_style.merge({
          size: default_style[:size] * 1.3,
          style: :bold_italic,
      })
    end

    def h5_style
      default_style.merge({
          size: default_style[:size] * 1,
      })
    end

    def h6_style
      default_style.merge({
          size: default_style[:size] * 0.85,
          style: :italic,
      })
    end

    def footer_style
      default_style.merge({
         size: default_style[:size] * 0.8,
         color: '666666',
         align: :center,
     })
    end

    available_styles = []
    instance_methods.grep(/_style$/).each do |method_name|
      style = method_name.to_s.sub('_style', '')
      available_styles << style.to_sym unless style == 'default'
    end
    define_method(:available_styles) do
      available_styles
    end

  end
end
