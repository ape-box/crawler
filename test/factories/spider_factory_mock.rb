
class SpiderFactoryMock
  attr_accessor :downloader

  def initialize(downloader)
    @downloader = downloader
  end

  def create_scraper(type, url, *args)
    case type
    when 'html'
      HtmlCrawler.new(url, @downloader)
    when 'css'
      CssCrawler.new(url, *args)
    end
  end

end
