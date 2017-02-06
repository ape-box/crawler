
class CssRegexParser
  attr_reader :content

  def initialize(content)
    @content = content
    @imports_rules = [CssImportsRule.new]
    @assets_rules = [CssUrlsRule.new]
  end

  def get_imports
    extract @imports_rules
  end

  def get_assets
    imports = get_imports
    assets = extract(@assets_rules).delete_if {|r| imports.include?(r) }
    ArrUniq.clean assets
  end

  private

    def extract(rules)
      list = []
      selectors = []

      rules.each {|rule| selectors += rule.selectors}
      selectors.each do |selector|
        reg = Regexp.new(selector, Regexp::IGNORECASE | Regexp::MULTILINE)
        list += @content.scan(reg).flatten
      end

      ArrUniq.clean list
    end

end
