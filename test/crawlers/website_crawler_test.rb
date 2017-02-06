require 'minitest/autorun'

class WebsiteCrawlerTest < Minitest::Test

  @@content = <<-HEREDOC
    <!doctype html>
    <html>
      <head>
        <link rel="stylesheet" href="/style.css" type="text/css" media="screen" />
        <script type="text/javascript" src="/app.js"></script>
        <style>
          @import 'theme.css';
        </style>
      </head>
      <body>
        <div class="menu">
          <a class="item" href="/" id="logo"><img src="/images/logo.png" alt="logo"></a>
          <a class="item" href="/about-us">About</a>
        </div>
        <div class="content">
          <p id="intro"><img src="/typography/drop-caps/l.png" alt="lorem">orem ipsum dolor sit amet.</p>
          <a href="#intro">top<a>
          <a href="what?i=am" style="background-image: url(pippo.jpg)">random<a>
        </div>
      </body>
    </html>
  HEREDOC

  @@style = <<-HEREDOC
      @import url("/common.css");
      @import 'template.css';

      .topbanner1 { background: url("topbanner1.png") #00D no-repeat fixed; }
      .topbanner2 { background: url("/topbanner2.png") #00D no-repeat fixed; }
      ul {
        list-style: square url(http://www.example.com/redball.png)
      }
  HEREDOC

  def test_class
    crawler = WebsiteCrawler.new('http://ape-box.com/', SpiderFactoryMock.new(DownloaderMock.new))
    assert !crawler.nil?
  end

  def test_contract
    assert_raises do
      crawler = WebsiteCrawler.new
    end
  end

  def test_get_pages_and_assets_empty
    crawler = WebsiteCrawler.new('http://ape-box.com/', SpiderFactoryMock.new(DownloaderMock.new))
    expected = [{'url' => 'http://ape-box.com/', 'assets' => []}]
    actual = crawler.get_pages_and_assets

    assert_equal expected, actual
  end

  def test_get_pages_and_assets
    mappings = {
      '*' => '',
      'http://ape-box.com/' => @@content,
      'http://ape-box.com/style.css' => @@style
    }
    crawler = WebsiteCrawler.new('http://ape-box.com/', SpiderFactoryMock.new(DownloaderMock.new(mappings)), DownloaderMock.new(mappings))
    common_assets = ['http://ape-box.com/style.css',
                     'http://ape-box.com/common.css',
                     'http://ape-box.com/template.css',
                     'http://ape-box.com/theme.css',
                     'http://ape-box.com/app.js',
                     'http://ape-box.com/images/logo.png',
                     'http://ape-box.com/pippo.jpg',
                     'http://ape-box.com/topbanner1.png',
                     'http://ape-box.com/topbanner2.png',
                     'http://www.example.com/redball.png',
                     'http://ape-box.com/typography/drop-caps/l.png'].sort
    expected = [
      {'url' => 'http://ape-box.com/', 'assets' => common_assets},
      {'url' => 'http://ape-box.com/about-us', 'assets' => []},
      {'url' => 'http://ape-box.com/what', 'assets' => []}
    ]

    actual = crawler.get_pages_and_assets
    assert_equal expected.length, actual.length
    actual.each do |ap|
      matching_page = expected.select {|ep| ep['url'] == ap['url']}
      assert_equal 1, matching_page.length
      assert_equal matching_page.first['assets'], ap['assets']
    end
  end

end
