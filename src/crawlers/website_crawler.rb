require 'uri'

class WebsiteCrawler
  attr_reader :url, :spider_factory, :pages, :links_toparse, :links_parsed, :download_service

  def initialize(url, spiderfactory=nil, downloader=nil)
    @url = url
    @originalhost = URI(@url).host
    reset_state

    unless spiderfactory.nil? || !spiderfactory.class.method_defined?('create_scraper')
      @spider_factory = spiderfactory
    else
      @spider_factory = SpiderFactory.new
    end

    unless downloader.nil? || !downloader.class.method_defined?('get_content')
      @download_service = downloader
    else
      @download_service = Downloader.new
    end
  end

  def get_pages_and_assets
    reset_state
    @links_toparse << @url
    url = @links_toparse.pop

    while !url.nil? do
      scrape_page(url)
      url = @links_toparse.pop
    end

    return @pages
  end

  private

    def scrape_page(url)
      return nil if is_parsed?(url)

      crawler = @spider_factory.create_scraper('html', url)
      assets = []
      assets += crawler.get_assets_list()
      assets += scrape_inline(url, @download_service.get_content(url))
      assets = scrape_assets(ArrUniq.clean(assets)).sort
      @pages << {'url' => url, 'assets' => assets}
      is_parsed!(url)

      crawler.get_links_list.each do |l|
        @links_toparse << l if (@originalhost == URI(l).host && !is_parsed?(l))
      end
    end

    # yep i will miss everything that's not provided with an extension
    def scrape_assets(assets)
      css_list = assets.collect {|d| d.dup}.select {|f| f.end_with?('.css')}
      parsed = []

      file = css_list.pop
      while !file.nil? && !parsed.include?(file)
        content = @download_service.get_content(file)
        crawler = @spider_factory.create_scraper('css', file, content)
        parsed << file

        imports = crawler.get_imports
        assets += crawler.get_assets
        assets += imports

        imports.each do |f|
          css_list << f unless (parsed.include?(file) || css_list.include?(file))
        end

        file = css_list.pop
      end

      assets
    end

    def scrape_inline(url, content)
      # 1. inline css x urls
      assets = []
      (CssInlinesRule.new).selectors.each do |selector|
        reg = Regexp.new(selector, Regexp::IGNORECASE | Regexp::MULTILINE)
        assets += content.scan(reg).flatten.collect {|f| MergeUrl.concat(URI(url), URI(f))}
      end

#      # 2. style tags x css
      (CssTagsRule.new).selectors.each do |selector|
        reg = Regexp.new(selector, Regexp::IGNORECASE | Regexp::MULTILINE)
        styles = content.scan(reg).flatten
        styles.each do |c|
          crawler = @spider_factory.create_scraper('css', url, c)
          assets += crawler.get_imports.collect {|f| MergeUrl.concat(URI(url), URI(f))}
          assets += crawler.get_assets.collect {|f| MergeUrl.concat(URI(url), URI(f))}
        end
      end

      ArrUniq.clean assets
    end

    def is_parsed?(url)
      normalized_url = url+'/' if url[-1] != '/'
      @links_parsed.include?(normalized_url)
    end

    def is_parsed!(url)
      normalized_url = url+'/' if url[-1] != '/'
      @links_parsed << normalized_url
    end

    def reset_state
      @pages = []
      @links_parsed = []
      @links_toparse = []
    end

end
