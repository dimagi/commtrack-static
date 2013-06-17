#encoding: utf-8
include Nanoc3::Helpers::HTMLEscape

module Nanoc3::Helpers
    module CustomSubs
        def table_text(text)
        	parse_yes(parse_no(mdashes(html_escape(text))))
        end
        def parse_no(text)
        	text.sub('NO', '<span class="no">no</span>')
        end
        def parse_yes(text)
        	text.sub('YES', '<span class="yes">yes</span>')
        end
        def mdashes(text)
        	text.sub('---', '&mdash;')
        end
    end
end