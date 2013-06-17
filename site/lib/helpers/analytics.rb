#encoding: utf-8
module Nanoc3::Helpers
    module AnalyticsHelper
        def use_analytics
            true
        end
        def google_analytics_account
        	'UA-26966364-1'
       	end
       	def track_event(category, item, description)
       		"onclick=\"_gaq.push(['_trackEvent', '"+category+"', '"+item+"', '"+description+"']);\""
       	end
    end
end