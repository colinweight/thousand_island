require 'thousand_island/version'

require 'prawn'
require 'prawn/table'

require 'thousand_island/style_sheet'
require 'thousand_island/template'
require 'thousand_island/builder'
require 'thousand_island/table'
require 'thousand_island/table_settings'

require 'thousand_island/components'
require 'thousand_island/components/base'
require 'thousand_island/components/header'
require 'thousand_island/components/footer'
require 'thousand_island/components/body'

require 'thousand_island/utilities/utilities'
require 'thousand_island/utilities/style_hash'

module ThousandIsland
  Error = Class.new(StandardError)
  TemplateRequiredError = Class.new(Error)
end
