require 'minitest/autorun'

class CssRegexParserTest < Minitest::Test

  def test_class
    parser = CssRegexParser.new ''
    assert !parser.nil?
  end

  def test_page_noimports
    parser = CssRegexParser.new ''
    assert_equal([], parser.get_imports)
  end

  def test_page_noassets
    parser = CssRegexParser.new ''
    assert_equal([], parser.get_assets)
  end

  def test_page_imports
    parser = CssRegexParser.new <<-HEREDOC
      @import url("common.css");
      @import 'template.css';
    HEREDOC
    assert_equal(['common.css', 'template.css'].sort, parser.get_imports.sort)
  end

  def test_page_assets
    parser = CssRegexParser.new <<-HEREDOC
      @import url("common.css");
      @import 'template.css';

      .topbanner { background: url("topbanner.png") #00D no-repeat fixed; }
      ul {
        list-style: square url(http://www.example.com/redball.png)
      }
    HEREDOC
    assert_equal(['topbanner.png', 'http://www.example.com/redball.png'].sort, parser.get_assets.sort)
  end

end
