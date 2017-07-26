# Xtractor
`Xtractor` provides an easy to use DSL for flexible, robust xml parsers.  The goal of extractor is to be able to write **One Parser to parse them all**. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xtractor', path: 'vendor/gems/' # Or whereever you have extractor stored
```

Since this gem is private, it can only be vendored into a project right now. 

**BEWARE:** Since i started working on this gem, another gem by the name of `xtractor` has been published to rubygems. So calling `gem install xtractor` will in fact install the wrong gem.

## Usage
#### Basics:

Including the `Xtractor` module in any Class turns it into a parser. 
Lets start simple:
```ruby
class WebParser
  include Xtractor

  node 'url'
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
  include Xtractor
  
  collection 'story'
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
  include Xtractor
  
  collection 'book' do
    attr_accessor :isbn
    node 'author'
    node 'title'
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
  include Xtractor
  
  # Creates accessors called 'url' and 'url=' but will look for nodes with the name url, link and website. Will return the first thing it finds.
  node %w[url link website]
  
  # Creates a property called main_header and will look for message and title
  node %w[message title], name: 'main_header'
  
  # This will define a property called width and will look for an attribute of the same name
  node '@width'
  
  # This will defina a property called `image_url` that will look for a node called 'image' and extract its 'url' attribute
  node 'image/@url'
  
  # This will look for a tag called encoded with the namespace content
  node 'content:encoded'
  
  # Here we define a transformation to make the parser return an integer
  node 'height', transform: :to_i
  
  # An alternative to the transformation is a type. The type must have a #parse method that receives a string
  node 'url', type: URI
  
  # A little bit of everything
  collection %w[image picture @img media:image], name: 'visual', type: URI
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### How it works (in a nutshell)
The `Xtractor` module defines certain class methods. Most importantly `node` and `collection` which work in similar ways.
`node` for example takes a `String` or an array of strings as well as some options. The `node` method instantiates a `TagParser` and adds it to the `@tags` property of the class that is including `Xtractor` (we'll call it MainClass from here on out), which holds an array of all the `TagParser`s and `CollectionParser`s . It also defines accessors for the *name* of the property the `node` parser should extract. 

The Parsers use an instance of `Xtractor::XPaths` to handle the array of tags that they are passed.
When everything is setup (i.e. the class is loaded), you can call `::parse` on your MainClass and pass it an XML string.  At this point the MainClass instantiates itself and the `TagParser`s and `CollectionParser`s extract a value from the xml, that is then assigned to the newly created MainClass instance.

#### Defining a parser with a block
When definen nested parsers, you would use a block. Like this:
```ruby
class ParserClass
  include Xtractor
  
  collection 'story' do
    node 'author'
    node 'title'
  end
end
```
When passing a block to a parser definition, a new class is created that basically looks like this:
```ruby
Class.new { include Xtractor }
```
The block is then `class_eval`ed on this anonymous class. Thats gives you a lot of flexibility in definen your parsers. 