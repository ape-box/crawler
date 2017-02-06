require 'nokogiri'

class HtmlNokogiriParser

  def initialize(html)
    @content = Nokogiri::HTML(html)
    @links_rules = [AnchorsRule.new]
    @assets_rules = [ImagesRule.new, LinksRule.new, ScriptsRule.new]
  end

  def get_links
    extract @links_rules
  end

  def get_assets
    extract @assets_rules
  end

  private

    def extract(rules)
      list = []

      rules.each do |rule|
        list += @content.xpath(rule.selector).collect do |e|
          next unless e.attributes.has_key?(rule.attribute)
          e.attributes[rule.attribute].value
        end
      end

      list
    end

end
