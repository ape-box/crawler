require 'minitest/autorun'

class CssCrawlerTest < Minitest::Test

  @@content = <<-HEREDOC
      @import url("/common.css");
      @import 'template.css';

      .topbanner1 { background: url("topbanner1.png") #00D no-repeat fixed; }
      .topbanner2 { background: url("/topbanner2.png") #00D no-repeat fixed; }
      ul {
        list-style: square url(http://www.example.com/redball.png)
      }
  HEREDOC

  def test_class
    crawler = CssCrawler.new 'http://ape-box.com/', ''
    assert !crawler.nil?
  end

  def test_contract
    assert_raises do
      crawler = CssCrawler.new
    end
  end

  def test_page_noassets
    crawler = CssCrawler.new 'http://ape-box.com/', ''

    expected = []
    actual = crawler.get_assets

    assert_equal expected, actual
  end

  def test_page_noimports
    crawler = CssCrawler.new 'http://ape-box.com/', ''

    expected = []
    actual = crawler.get_imports

    assert_equal expected, actual
  end

  def test_page_assets
    crawler = CssCrawler.new 'http://ape-box.com/foobar/', @@content

    actual = crawler.get_assets.sort
    expected = ['http://ape-box.com/foobar/topbanner1.png',
                'http://ape-box.com/topbanner2.png',
                'http://www.example.com/redball.png'].sort

    assert_equal(expected, actual)
  end

  def test_page_assets_dirtyurl
    crawler = CssCrawler.new 'http://ape-box.com/style.css', @@content

    actual = crawler.get_assets.sort
    expected = ['http://ape-box.com/topbanner1.png',
                'http://ape-box.com/topbanner2.png',
                'http://www.example.com/redball.png'].sort

    assert_equal(expected, actual)
  end

  def test_page_imports
    crawler = CssCrawler.new 'http://ape-box.com/foobar/', @@content

    actual = crawler.get_imports.sort
    expected = ['http://ape-box.com/common.css',
                'http://ape-box.com/foobar/template.css'].sort

    assert_equal(expected, actual)
  end

end
