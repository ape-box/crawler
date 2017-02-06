class CssImportsRule
  def selectors
    [
      '@import[ ]+url\\([\'"]?([^\'"]+)',
      '@import[ ]+[\'"]{1}([^\'"]+)'
    ]
  end
end
