#encoding: utf-8
module Nanoc3::Helpers
    module CCHQNavigation
      include Nanoc::Helpers::Rendering
      
      def build_navigation(order, item, include_pages=false)  
        nav_list = []
        pages = []
        order.each do |page_nav|
          if page_nav.kind_of?(Array)
          
            dropdown_title = @config[:nav_dropdowns][page_nav[0].to_sym]["en".to_sym]
            dropdown_menu, pages = build_navigation(page_nav[1], item, true)
            
            is_active = false
            pages.each do |p|
              is_active = ((p[:slug] == item[:slug]) || is_active)
            end
            
            nav_list.push(render('_menu-dropdown', :title => dropdown_title, :menu => dropdown_menu, :is_active => is_active))
          
          else
            page = get_page(page_nav, item)
            pages.push(page)
            
            url = get_page_url(page)
            css_class = (page[:slug] == item[:slug]) ? " class=\"selected\"" : ""
            
            nav_list.push("<li#{css_class}><a href=\"#{url}\">#{page[:short_title]}</a></li>")
          end
        end
        
        nav_html = nav_list.join("\n")
        if (include_pages)
          return nav_html, pages
        else
          return nav_html
        end
      end
      
      def get_page_url(page)
        return "#{get_locale_prefix(page)}/#{page[:slug]}/"
      end
      
      def get_locale_prefix(item)
        # prefix = "/#{item[:locale]}"
#         if is_prefix_default(prefix)
#           prefix = ""
#         end
        return ""
      end
      
      def is_prefix_default(prefix)
        return prefix == "/#{@config[:default_locale]}"
      end
      
      def get_page_for_locale(item, loc)
        # prefix = "/#{loc}"
#         if is_prefix_default(prefix)
#           prefix = ""
#         end
        prefix = ""
        filename = item[:meta_filename]
        parent_id = filename.split('/')[0..-2].join('/')
        page = @items.find { |i| i.identifier == "/#{parent_id}/" }
        return get_page_url(page)
      end
      
      def get_page(page_slug, item)
        return @items.find { |i| i.identifier == "/pages/#{page_slug}/" } 
      end
      
      def get_sections(page, section_slugs=nil)
        sections = []
        if section_slugs.nil?
          section_slugs = page[:sections]
        end
        section_slugs.each do |slug|
          path = page.identifier.split("/")
          # HACK / lazy
          if path.index("special") != nil
            path = path[1..4]
          else
            path = path[1..3]
          end
          root = path.join('/')
          section = @items.find { |i| i.identifier == "/#{root}/sections/#{slug}/" }
          if section
            sections.push(section)
          end
        end
        return sections
      end
      
      def get_parent_page(section)
        return get_page(section.identifier.split('/')[3], section)
      end
      
      def css_id(identifier)
        	identifier.split('/').last.downcase
      end	
      def make_alt_text(identifier)
      	identifier.sub('-', ' ')
      end
      
    end
end