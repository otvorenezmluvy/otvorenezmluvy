module BootstrapHelper
  def nav_link(content, path)
    content_tag :li, class: current_page?(path) ? :active : nil do
      link_to content, path
    end
  end
end
