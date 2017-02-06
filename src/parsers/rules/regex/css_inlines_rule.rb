class CssInlinesRule
  def selectors; ['style=(?:"|\')[^>]*url\\([\'"]?([^\\)\'"]+)']; end
end
