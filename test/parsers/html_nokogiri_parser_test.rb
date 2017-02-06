require 'minitest/autorun'

class HtmlNokogiriParserTest < Minitest::Test

  def test_class
    parser = HtmlNokogiriParser.new ''
    assert !parser.nil?
  end

  def test_page_noelements
    parser = HtmlNokogiriParser.new <<-HEREDOC
      <!doctype html>
      <html />
    HEREDOC
    assert_equal([], parser.get_links)
  end

  def test_page_links
    parser = HtmlNokogiriParser.new <<-HEREDOC
      <!doctype html>
      <html>
        <body>
          <div class="menu">
            <a class="item" href="/" id="logo">Home</a>
            <a class="item" href="/about-us">About</a>
          </div>
        </body>
      </html>
    HEREDOC
    assert_equal(['/', '/about-us'], parser.get_links)
  end

  def test_page_assets
    parser = HtmlNokogiriParser.new <<-HEREDOC
      <!doctype html>
      <html>
        <head>
          <link rel="stylesheet" href="/style.css" type="text/css" media="screen" />
          <script type="text/javascript" src="/app.js"></script>
        </head>
        <body>
          <div class="menu">
            <a class="item" href="/" id="logo"><img src="/images/logo.png" alt="logo"></a>
            <a class="item" href="/about-us">About</a>
          </div>
          <div class="content">
            <p><img src="/typography/drop-caps/l.png" alt="lorem">orem ipsum dolor sit amet.</p>
          </div>
        </body>
      </html>
    HEREDOC
    assert_equal(['/style.css', '/app.js', '/images/logo.png', '/typography/drop-caps/l.png'].sort, parser.get_assets.sort)
  end

end
