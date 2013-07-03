module RySafe
  class EntryPresenter < Presenter
    def to_s
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
comment:               #{model.comment || "--"}
      HEREDOC
    end
  end
end
