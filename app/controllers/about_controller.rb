class AboutController < ApplicationController
  def show
  end

  def markdown_render
    md = self.class.render(action: "#{params[:id]}.md", layout: false)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true)
    markdown = Redcarpet::Markdown.new(renderer, autolink: true)
    markdown.render(md).html_safe
  end
end
