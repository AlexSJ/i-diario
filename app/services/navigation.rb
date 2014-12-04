module Navigation
  def self.draw_breadcrumbs(item, context)
    BreadcrumbsBuilder.build(item, context)
  end

  def self.draw_***REMOVED***s(item, context)
    MenuBuilder.build(item, context)
  end

  def self.draw_title(item, show_icone, context)
    TitleBuilder.build(item, show_icone, context)
  end
end

