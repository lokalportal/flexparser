# Flexparser
`Flexparser` provides an easy to use DSL for flexible, robust xml parsers.  The goal of flexparser is to be able to write **One Parser to parse them all**. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flexparser', path: 'vendor/gems/' # Or whereever you have eflexparser stored
```

Since this gem is private, it can only be vendored into a project right now. 

**BEWARE:** Since i started working on this gem, another gem by the name of `flexparser` has been published to rubygems. So calling `gem install flexparser` will in fact install the wrong gem.

## Usage
#### Basics:

Including the `Flexparser` module in any Class turns it into a parser. 
Lets start simple:
```ruby
class WebParser
  include Flexparser

  property 'url'
end
```
Now this class is able to parse xml similar to this:
```xml
<url>www.my-page.com</url>
```
Now your parser can do this:
```ruby
# Assuming the xml variable holds the xml code mentioned above
website = WebParser.parse xml
webite.url #=> 'www.my-page.com'
```

#### Collections
A `node` command will only return the first value it finds. When you have multiple nodes that interest you, you can get a `collection` of them.
```ruby
books = '
		<work author="H.P. Lovecraft">
                 <story>The Call of Cthulhu</story>
                 <story>Dagon</story>
                 <story>The Nameless City</story>
                 </work>
                '
                 
class LovecraftParser
  include Flexparser

  property 'story', collection: true
end

work = LovecraftParser.parse books
work.story #=> ['The Call of Cthulhu', 'Dagon', 'The Nameless City']
```

#### Nested Parsers
Sometimes you want more than to just xtract a String. This way you can make your parser return complex Objects and nest parsers as deep as you like.
```ruby
library = "
<book>
  <author>J. R. R. Tolkien</author>
  <title>The Hobbit</title>
</book>
<book>
  <author>Suzanne Collins</author>
  <title>The Hunger Games</title>
</book>"

class LibraryParser
  include Flexparser
  
  property 'book', collection: true do
    attr_accessor :isbn
    property 'author'
    property 'title'
  end
end

lib = LibraryParser.parse library
lib.book.second.authro #=> 'Suzanne Collins'
lib.book.first.title #=> 'The Hobbit'
lib.book.first.isbn = '9780582186552'
lib.book.first.isbn #=> '9780582186552'
```
With nested parsers, anonymous classes are defined inside an existing parser. Therefore you can define methods all you like (should the need arise).

#### Tag Definitions
You might not always know (or it might not always be the same), what the information you are looking for is called. If that is the case, you can define multiple tags for the same property. Here are a few examples:
```ruby
class UniParser
  include Flexparser
  
  # Creates accessors called 'url' and 'url=' but will look for nodes with the name url, link and website. Will return the first thing it finds.
  property %w[url link website]
  
  # Creates a property called main_header and will look for message and title
  property %w[message title], name: 'main_header'
  
  # This will define a property called width and will look for an attribute of the same name
  property '@width'
  
  # This will define a property called `image_url` that will look for a node called 'image' and extract its 'url' attribute
  property 'image/@url'
  
  # This will look for a tag called encoded with the namespace content
  property 'content:encoded'
  
  # Here we define a transformation to make the parser return an integer
  property 'height', transform: :to_i
  
  # An alternative to the transformation is a type. The type must have a #parse method that receives a string
  property 'url', type: URI
  
  # A little bit of everything
  property %w[image picture @img media:image], name: 'visual', type: URI, collection: true
end
```
### Configuration
You can configure Flexparser by using a block (for example in an initializer) like so:
```ruby
Flexparser.configure do |config|
  config.option = value
end
```
At time of writing there are two Options:

####  `explicit_property_naming` 
**Default: ** `true`
If this is `true` you need to specify a `:name` for your `property` everytime there is more than one tag in your tag-list.
Example: 
```ruby
# Bad!
property %w[url link website]
    
# Good!
property %w[url link website], name: 'website'
    
# Don't care! Unambiguous!
property 'url'
property ['width']
```
#### `retry_without_namespaces`
**Default:** `true`
If true, `Flexparser` will add a second set of xpaths to the list of tags you specified, that will ignore namespaces completely.
Example: 
```ruby
Flexparser.configure { |c| c.retry_without_namespaces = false }
class SomeParser
  property 'inventory'
end

xml = "<inventory xmlns="www.my-inventory.com">james</inventory>"

# The inventory can't be found because it is namespaced.
SomeParser.parse(xml).inventory #=> nil :(

Flexparser.configure { |c| c.retry_without_namespaces = true }
class SomeBetterParser
  property 'inventory'
end

xml = "<inventory xmlns="www.my-inventory.com">james</inventory>"

# The inventory can be found because we don't care.
SomeParser.parse(xml).inventory #=> 'james'
```
The Xpath used here adheres to xpath version 1.X.X and uses the name property `.//[name()='inventory']`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### How it works (in a nutshell)
The `Flexparser` module defines certain class methods. Most importantly `property` works in similar ways.
`property` takes a `String` or an array of strings as well as some options. The `property` method instantiates a `TagParser` and adds it to the `@tags` property of the class that is including `Flexparser` (we'll call it MainClass from here on out), which holds an array of all the `TagParser`s and `CollectionParser`s . It also defines accessors for the *name* of the property the `property` parser should extract. 

The Parsers use an instance of `Flexparser::XPaths` to handle the array of tags that they are passed.
When everything is setup (i.e. the class is loaded), you can call `::parse` on your MainClass and pass it an XML string.  At this point the MainClass instantiates itself and the `TagParser`s and `CollectionParser`s extract a value from the xml, that is then assigned to the newly created MainClass instance.

#### Defining a parser with a block
When defining nested parsers, you would use a block. Like this:
```ruby
class ParserClass
  include Flexparser
  
  property 'story', collection: true do
    property 'author'
    property 'title'
  end
end
```
When passing a block to a parser definition, a new class is created that basically looks like this:
```ruby
Class.new { include Flexparser }
```
The block is then `class_eval`ed on this anonymous class. Thats gives you a lot of flexibility in definen your parsers. 
