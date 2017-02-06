require 'minitest/autorun'

class HtmlCrawlerTest < Minitest::Test

  @@content = <<-HEREDOC
    <!doctype html>
    <html>
      <head>
        <link rel="stylesheet" href="/style.css" type="text/css" media="screen" />
        <script type="text/javascript" src="/app.js"></script>
      </head>
      <body>
        <div class="menu">
          <a class="item" href="/" id="logo"><img src="./images/logo.png" alt="logo"></a>
          <a class="item" href="/about-us">About</a>
        </div>
        <div class="content">
          <p id="intro"><img src="/typography/drop-caps/l.png" alt="lorem">orem ipsum dolor sit amet.</p>
          <a href="#intro">top<a>
          <a href="what?i=am">random<a>
        </div>
      </body>
    </html>
  HEREDOC

  def test_class
    crawler = HtmlCrawler.new 'http://ape-box.com/', DownloaderMock.new
    assert !crawler.nil?
  end

  def test_contract
    assert_raises do
      crawler = HtmlCrawler.new
    end
  end

  def test_page_noassets
    downloader = DownloaderMock.new
    crawler = HtmlCrawler.new 'http://ape-box.com/', downloader

    expected = []
    actual = crawler.get_assets_list

    assert_equal expected, actual
  end

  def test_page_nolinks
    downloader = DownloaderMock.new
    crawler = HtmlCrawler.new 'http://ape-box.com/', downloader

    expected = []
    actual = crawler.get_links_list

    assert_equal expected, actual
  end

  def test_page_assets
    downloader = DownloaderMock.new({'http://ape-box.com/' => @@content})
    crawler = HtmlCrawler.new 'http://ape-box.com/', downloader

    actual = crawler.get_assets_list.sort
    expected = ['http://ape-box.com/style.css',
                'http://ape-box.com/app.js',
                'http://ape-box.com/images/logo.png',
                'http://ape-box.com/typography/drop-caps/l.png'].sort

    assert_equal(expected, actual)
  end

  def test_subpage_assets
    downloader = DownloaderMock.new({'http://ape-box.com/foo/' => @@content})
    crawler = HtmlCrawler.new 'http://ape-box.com/foo/', downloader

    actual = crawler.get_assets_list.sort
    expected = ['http://ape-box.com/style.css',
                'http://ape-box.com/app.js',
                'http://ape-box.com/foo/images/logo.png',
                'http://ape-box.com/typography/drop-caps/l.png'].sort

    assert_equal(expected, actual)
  end

  def test_page_links
    downloader = DownloaderMock.new({'http://ape-box.com/' => @@content})
    crawler = HtmlCrawler.new 'http://ape-box.com/', downloader

    actual = crawler.get_links_list.sort
    expected = ['http://ape-box.com/',
                'http://ape-box.com/about-us',
                'http://ape-box.com/what'].sort

    assert_equal(expected, actual)
  end

  def test_subpage_links
    downloader = DownloaderMock.new({'http://ape-box.com/foo/' => @@content})
    crawler = HtmlCrawler.new 'http://ape-box.com/foo/', downloader

    actual = crawler.get_links_list.sort
    expected = ['http://ape-box.com/',
                'http://ape-box.com/about-us',
                'http://ape-box.com/foo/what'].sort

    assert_equal(expected, actual)
  end

end
