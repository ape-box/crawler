class DownloaderMock
  attr_accessor :content

  def initialize(content=nil)
    unless content.nil?
      @content = content
    else
      @content = {'*' => '<html />'}
    end
  end

  def get_content(url)
    if @content.key? url
      return @content[url]
    end

    if @content.key? '*'
      return @content['*']
    end

    '<html />'
  end

end

