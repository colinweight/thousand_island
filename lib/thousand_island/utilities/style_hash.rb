module ThousandIsland
  # A subclass of Hash, automatically adds keys that mirror other keys to allow
  # for a couple of small differences in the Prawn options hashes:
  #     :font_style = :style
  #     :styles = :style and puts it into an Array
  class StyleHash < Hash
    def initialize(style={})
      super()
      self.merge!(style)
    end

    def [](key)
      return self[:size] if key == :font_size
      return [self[:style]] if key == :styles
      super
    end

  end

end
