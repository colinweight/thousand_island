# Thousand Island
**Dressing for Prawn**

[![GitHub version](https://badge.fury.io/gh/colinweight%2Fthousand_island.png)](http://badge.fury.io/gh/colinweight%2Fthousand_island)  [![Code Climate](https://codeclimate.com/github/colinweight/thousand_island/badges/gpa.png)](https://codeclimate.com/github/colinweight/thousand_island)  ![Build Status](https://travis-ci.org/colinweight/thousand_island.png?branch=master)


[Prawn](https://github.com/prawnpdf/prawn) is awesome. It has some amazing functionality, and you can get anything that's in your head onto a PDF document with some Ruby code. For me though, as wonderful as that is, I normally only need a repeating header and footer, and then some text and maybe a table in between them. This is where **Thousand Island** comes in. A few simple commands should get you set up with a template that you can use application wide, and then all you need to worry about is getting the right content into the document.

> Note: ThousandIsland is not meant to be a substitute for learning Prawn, you will get more out of it if you do. The excellent [Prawn Manual](http://prawnpdf.org/manual.pdf) is a great place to start.

## Installation

Add this line to your application's Gemfile:

    gem 'thousand_island'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thousand_island

## Usage

ThousandIsland uses the following classes to get the job done:

**ThousandIsland::Template** - The common layout and formatting for your pdfs live in here

**ThousandIsland::Builder** - Subclass the Builder for your actual business logic for the pdf itself

**ThousandIsland::StyleSheet** - A mixin for defining common styles to be used by your Template

A suggested directory structure for a Rails app is as follows, but it's entirely up to you:

```
app/
└── pdf_builders/
	├── my_builder.rb
    └── templates/
		├── my_template.rb  
		├── my_style_sheet.rb
```
For a non-Rails application, the `lib` directory can be used instead of the `app` directory, but it's all up to you.

### Creating a Template

The Template class is where you can define elements that may be common to all (or some) documents within your application. It is likely that a common style will be required, so defining it in a Template and then using that Template subclass in any custom Builders DRYs up your pdf generation, as well as allowing for easy restyling across the whole application.

Typically, the Template subclass would define the settings for the Prawn Document, as well as the settings for the header and footer. Add your own or override any existing settings in the `settings` method. Any options passed into the constructor as a Hash will be merged with these settings, and the defaults.

Content for the header and footer will be defined in the methods `header_content` and `footer_content`. These methods are passed as a block when the pdf is rendered. Any standard Prawn methods may be used (including bounding boxes or any other layout tools). In addition, any of the styles from the `StyleSheet` can be applied as helper methods. For instance, the default style sheet has a `h1_style` method that returns a  ThousandIsland::StyleHash, so in your code you can use:
```ruby
  h1 "My Document Header"
```
and Prawn will render the text in the style set in the `h1_style` ThousandIsland::StyleHash.
In addition to the supplied style methods, you can create a custom method:
```ruby
  def magic_style
    ThousandIsland::StyleHash.new({
      size: 15
      style: bold
    })
  end
```
As long as the method ends in the word "_style" and returns a Hash, you magically get to do this:

```ruby
  magic "My magic text is bold and size 15!!"
```

The method may return a standard Hash, but it is safer to return a ThousandIsland::StyleHash, as this dynamically duplicates a few keys to accommodate using the style in normal Prawn text methods as well as formatted text boxes, which use a slightly different convention. You don't have to worry about that if you use the ThousandIsland::StyleHash.

Alternatively, your method could do this:
```ruby
  def magic_style
    h1_style.merge({
      size: 15
      style: bold
    })
  end
```
The following is an example of a custom template that subclasses
ThousandIsland::Template -
```ruby
  class MyTemplate < ThousandIsland::Template
    include MyCustomStyleSheet # optional

    # settings here are merged with and override the defaults
    def settings
      {
        header: {
          height: 55,
          render:true,
          repeated: true
        },
        footer: {
          render:true,
          height: 9,
          numbering_string: 'Page <page> of <total>',
          repeated: true
        }
      }
    end

    def header_content
      # Standard Prawn syntax
      pdf.image "#{pdf_images_path}/company_logo.png", height: 30
    end

    def footer_content
      # Using the magic method we get from the footer_style
      footer "www.mycompanyurl.com"
    end

    def pdf_images_path
      # How you go about this sort of thing is entirely up to you
	  "#{Rails.root}/app/assets/pdf_images"
    end
  end
```
>Note: The Footer is a three column layout, with the numbering on the right column and the content defined here in the middle. More flexibility will be added in a later version.

Optional:
Add a `body_content` method to add content before whatever the Builder defines in it's method of the same name.

### StyleSheets

The StyleSheet is designed to be a mixin to the Template class. It may also be included into other modules to define custom StyleSheets.

Methods should return a StyleHash object rather than a vanilla Hash, as it has some customisation to help it work with Prawn. The default_style is used as the starting point for all other styles. For instance, the `default_style[:size]` value is multiplied in the heading styles, so changing the default style size value will have a cascading effect. Check the source for the default values and override as preferred.

An example of a custom StyleSheet:
```ruby
  module MyStyleSheet
    include ThousandIsland::StyleSheet
    
    def default_style
      super.merge({
        size: 12,
        color: '222222'
      })
    end
    
    def h1_style
      super.merge({ align: :center })
    end
  end
```

### Creating a Builder

Your Builder class is where you will put the necessary logic for rendering the final pdf. It's up to you how you get the data into the Builder. It will depend on the complexity. You might just pass an Invoice object (`MyBuilder.new(invoice))`) or you may have a bunch of methods that are called by an external object to get the data where it needs to be.

You must declare which Template class you will be using. Failing to do so will raise a `TemplateRequiredError` when you call the build method. Declare the template with the following in the main class body:
```ruby
  uses_template MyTemplate
```

Your Builder can have a `filename` method, which will help a Rails Controller or other class determine the name to use to send the file to the browser or save to the filesystem (or both). Without this method it will have a default name, so you may choose to put the naming logic for your file elsewhere, it's up to you.

You must have a `body_content` method that takes no arguments (or the pdf will be empty!). This is the method that is passed around internally in order for Prawn to render what is in the method. You can use raw Prawn syntax, or any of the style magic methods to render to the pdf. You may also call other methods from your `body_content` method, and use Prawn syntax and magic methods in those too. 

A Builder example might be:
```ruby
  class MyBuilder < ThousandIsland::Builder
    uses_template MyTemplate
  
    attr_reader :data
    
    def initialize(data={})
      @data = data
      # do something with the data...
    end
    
    def filename
      "Document#{data.id_number}"
    end
    
    def body_content
      # call custom methods, magic methods or call Prawn methods directly:
      h1 'Main Heading'
      display_info
      body 'Main text in here...'
    end
    
    # Custom method called by body_content
    def display_info
      body "Written by: #{data.author}"
      pdf.image data.avatar, height: 20
    end
  end
```

Finally, to get the finished pdf from your Builder, call the `build` method like so:
```ruby
  pdf = my_builder.build
```

Optional:

Define a `header_content` method to add content below whatever is defined in the Template. This will be repeated according to the header settings in the Template.

Define a `footer_content` method to add content above whatever is defined in the Template. This will be repeated according to the footer settings in the Template.

Define a `settings` method that returns a Hash. This will be passed to the Template class and will override any of the Template default settings.

#### Using the Builder in a Rails Application

Your Controller can look something like this:

```ruby
def show
    @thing = Thing.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        data = { thing: @thing }  # How you structure this is up to you, it's your Class!!
        builder = MyBuilder.new(data)
        send_data builder.build, filename: builder.filename,
          type: "application/pdf",
          disposition: "inline" # Leave blank to render as a download
      end
    end
  end
```

If your controller for getting the data for a PDF is that simple, then you're pretty lucky. Normally we're going to want a PDF file to render a few things at once, so you might build a service object that formats the data, and use as follows:

```ruby
def show
    respond_to do |format|
      format.html do
        @thing_for_html_view = Thing.find(params[:id])
      end
      format.pdf do
      	# Tell the service object to do it's thing and return the Builder
        builder = ThingPdfServiceObject.new(params)
        send_data builder.build,
              filename: builder.filename,
              type: "application/pdf",
              disposition: "inline" # Leave blank to render as a download
      end
    end
  end
```

These are only suggestions, as you can probably tell there is nothing tying you down to a particular way of building and delivering the document. You might even want to save it to the file system, or upload to S3. You could override the build method if you wanted to:
```ruby
  def build
  	pdf = super
    # Save, upload, send or do whatever....
  end
```
However, that kind of logic seems beyond the scope of the Builder, and should proabably be in the consumer of your Builder class, rather than the builder itself.

## Default Styles
Out of the box, ThousandIsland gives you some generic styles with default values. Override any of the values in your custom Stylesheet, or your Template. Create your own entirely new style in either of those places too, and get the magic method for free.

The default styles are:
##### body
```ruby
{
  :size => 10, # Inherited from default_style
  :style => :normal, # Inherited from default_style
  :align => :left, # Inherited from default_style
  :leading => 1, # Inherited from default_style
  :inline_format => true, # Inherited from default_style
  :color => "000000" # Inherited from default_style
}
```
##### h1
```ruby
{
  :size => 18, # Calcuated as 1.8 * default_style[:size]
  :style => :bold,
  :align => :left, # Inherited from default_style
  :leading => 8,
  :inline_format => true, # Inherited from default_style
  :color => "000000" # Inherited from default_style
}
```
##### h2
```ruby
{
  :size => 15, # Calcuated as 1.5 * default_style[:size]
  :style => :bold,
  :align => :left, # Inherited from default_style
  :leading => 4,
  :inline_format => true, # Inherited from default_style
  :color => "000000" # Inherited from default_style
}
```
##### h3
```ruby
{
  :size => 14, # Calcuated as 1.4 * default_style[:size]
  :style => :bold,
  :align => :left, # Inherited from default_style
  :leading => 4,
  :inline_format => true, # Inherited from default_style
  :color => "000000" # Inherited from default_style
}
```
##### h4
```ruby
{
  :size => 11, # Calcuated as 1.1 * default_style[:size]
  :style => :bold_italic,
  :align => :left, # Inherited from default_style
  :leading => 4,
  :inline_format => true, # Inherited from default_style
  :color => "000000" # Inherited from default_style
}
```
##### h5
```ruby
{
  :size => 10, # Calcuated as 1 * default_style[:size]
  :style => :normal, # Inherited from default_style
  :align => :left, # Inherited from default_style
  :leading => 4,
  :inline_format => true, # Inherited from default_style
  :color => "000000" # Inherited from default_style
}
```
##### h6
```ruby
{
  :size => 8.5, # Calcuated as 0.85 * default_style[:size]
  :style => :italic,
  :align => :left, # Inherited from default_style
  :leading => 4,
  :inline_format => true, # Inherited from default_style
  :color => "000000" # Inherited from default_style
}
```
##### footer
```ruby
{
  :size => 0.8, # Calcuated as 0.8 * default_style[:size]
  :style => :normal,
  :align => :left, # Inherited from default_style
  :leading => 1, # Inherited from default_style
  :inline_format => true, # Inherited from default_style
  :color => "666666"
}
```

## To come...
- Easy (and repeatable) Table formatting
- Easy list rendering and styling (including nested lists)
- More flexibility in the Footer layout
- (Possibly) Command line functions to create common subclass files 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
