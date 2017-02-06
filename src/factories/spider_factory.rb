
class SpiderFactory

  def create_scraper(type, *args)
    case type
    when 'html'
      HtmlCrawler.new(*args)
    when 'css'
      CssCrawler.new(*args)
    end
  end

end
