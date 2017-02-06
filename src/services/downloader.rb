require 'net/http'

# just a wrapper for IoC
class Downloader

  def get_content(url)
    Net::HTTP.get(URI.parse(url))
  end

end
