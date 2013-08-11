module RySafe
  class EntryPresenter < NodePresenter
    def content
      <<-HEREDOC
dir:                   #{model.directory || "--"}
title:                 #{model.name || "--"}
=======================================
username:              #{model.username || "--"}
password:              #{model.password || "--"}
password_confirmation: #{model.password_confirmation || "--"}
valid:                 #{model.valid?}
website:               #{model.website || "--"}
tags:                  #{model.tags.map(&:name).join(', ') || "--"}
comment:               #{model.comment.gsub("\n", "\n#{" "*23}") || "--"}
      HEREDOC
    end
  end
end
