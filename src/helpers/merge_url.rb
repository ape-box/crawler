
# Need to be structured better!
class MergeUrl
  class << self
    def concat(base, link)
      # Internal url
      if link.to_s.start_with?('#')
        return nil
      end

      # External url
      if link.to_s.start_with?('http')
        return link.to_s
      end
      if link.to_s.start_with?('//')
        return "#{base.scheme}:#{link.to_s}"
      end

      # Unhandled url
      if /^[a-z0-9]+:/i.match(link.to_s)
        return nil
      end

      port = base.port == 80 ? '' : ":#{base.port}"

      # Absolute url
      if link.path.start_with?('/')
        return "#{base.scheme}://#{base.host}#{port}#{link.to_s}"
      end

      # Fixing current page
      root_address = base.path
      root_address = '/' if root_address == ''
      if root_address[-1] != '/'
        root_address = base.path.gsub(/[^\/]+$/, '')
      end

      # Cleaning path
      link_address = link.path
      if (link.path.start_with?('./'))
        link_address = link.path.gsub(/^\.\//, '')
      end

      # Relative url
      return "#{base.scheme}://#{base.host}#{port}#{root_address}#{link_address}"
    end
  end
end
