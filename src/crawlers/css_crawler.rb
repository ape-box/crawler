
class CssCrawler
  attr_reader :url, :content

  def initialize(url, content)
    @url = url
    # if this is the full url to the file, instead of the url of the referencin page, then strip the file part
    @url.gsub!(/([^\/]+\.css[^\/]*)$/im, '') unless /[^\/]+\.css[^\/]*$/.match(url).nil?
    @content = content
  end

  def get_assets
    list = parser.get_assets.collect {|a| MergeUrl.concat(URI(@url), URI(a))}
    ArrUniq.clean list
  end

  def get_imports
    list = parser.get_imports.collect {|a| MergeUrl.concat(URI(@url), URI(a))}
    ArrUniq.clean list
  end

  private

    def parser
      @parser = CssRegexParser.new(@content) if @parser.nil?
      @parser
    end

end
