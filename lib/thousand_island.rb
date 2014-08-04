require "thousand_island/version"

require "prawn"

require "thousand_island/builder"
require "thousand_island/template"

require "thousand_island/components"
require "thousand_island/components/base"
require "thousand_island/components/header"
require "thousand_island/components/footer"

module ThousandIsland
  class Error < StandardError; end
  class TemplateRequiredError < Error; end
end

KIsland = ThousandIsland