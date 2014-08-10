module ThousandIsland
  module Utilities

    module DeepMerge

      #Take a number of hashes and merge them into one, respecting
      # the structure and nesting according to the pdf options hash.
      # Hashes work in order of precedence, the first in the array
      # overrides, the second, etc.
      #
      # @param hashes [*Hash] A number of hashes to merge, in the order of precedence
      #
      # @return [Hash] the merged values
      def self.merge_options(*hashes)
        hashes.reverse!
        merged = {}
        footer = merge_footer(*hashes)
        header = merge_header(*hashes)
        body = merge_body(*hashes)
        hashes.each do |h|
          merged.merge!(h)
        end
        merged[:footer] = footer
        merged[:header] = header
        merged[:body] = body
        merged
      end

      def self.merge_footer(*hashes)
        keys = [:numbering_options, :style]
        merge_for_key_and_nested_keys(:footer, keys, *hashes)
      end

      def self.merge_header(*hashes)
        merge_for_key_and_nested_keys(:header, [], *hashes)
      end

      def self.merge_body(*hashes)
        merge_for_key_and_nested_keys(:body, [], *hashes)
      end

      def self.merge_for_key_and_nested_keys(key, keys, *hashes)
        temp = {}
        merged = {}
        hashes.each do |h|
          keys.each do |k|
            temp[k] = {} unless temp.has_key? k
            temp[k].merge!(h[key][k]) if h[key] && h[key][k]
          end
          merged.merge!(h[key]) if h[key]
        end
        merged.merge(temp)
      end

    end

  end
end