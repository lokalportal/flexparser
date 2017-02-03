require 'test_helper'

class XtractorTest < Minitest::Test
  def xml
    <<-XML
      <bookstore>
        <book>
          <title>The Witcher</title>
          <isbn>10</isbn>
        </book>
        <book>
          <title>Lord of the Rings</title>
          <isbn>11</isbn>
        </book>
        <book>
          <title>Harry Potter</title>
          <isbn>12</isbn>
        </book>
        <category>Fantasy</category>
      </bookstore>
    XML
  end

  def parser
    Class.new do
      include ::Xtractor

      node 'bookstore' do
        collection 'book' do
          node 'title'
          node 'isbn'
        end
        node 'category'
      end
    end
  end

  def feed
    parser.parse xml
  end

  def test_inherits_anonymous
    assert(feed.bookstore.class < Xtractor::AnonymousParser)
  end

  def test_defines_accessors
    assert feed.bookstore.respond_to?(:category)
    assert feed.bookstore.respond_to?('category=')
  end

  def test_parses_bookstore_correctly
    assert_equal feed.bookstore.category, 'Fantasy'
  end

  def test_collection_parsing
    assert_equal feed.bookstore.book.count, 3
    assert_equal feed.bookstore.book.first.isbn, 10.to_s
  end
end
