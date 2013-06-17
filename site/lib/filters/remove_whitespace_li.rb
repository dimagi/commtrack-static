module Nanoc3::Filters

  class RemoveSpacingRoundPre < Nanoc3::Filter

    identifiers :remove_newline

    def run(content, arguments={})
      content.gsub(/\n/, "")
    end

  end

end