require 'uri'

class HtmlCrawler
  attr_reader :url, :download_service

  # remove the "downloader" and replace with the content
  def initialize(url, downloader=nil)
    @url = url

    unless downloader.nil? || !downloader.class.method_defined?('get_content')
      @download_service = downloader
    else
      @download_service = Downloader.new
    end
  end

  def get_assets_list
    list = parser.get_assets.collect {|a| MergeUrl.concat(URI(@url), URI(a))}
    ArrUniq.clean list
  end

  def get_links_list
    list = parser.get_links.collect {|a| MergeUrl.concat(URI(@url), URI(a))}
    ArrUniq.clean list
  end

  private

    def page_content
      @content = @download_service.get_content(@url) if @content.nil?
      @content
    end

    def parser
      @parser = HtmlNokogiriParser.new(page_content) if @parser.nil?
      @parser
    end

end
