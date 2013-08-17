module RySafe
  class EntryPresenter < NodePresenter
    def name
      helper.colorize(super, :name)
    end

    def content
      <<-HEREDOC
dir:                   #{helper.colorize(model.directory, :directory) || "--"}
title:                 #{helper.colorize(model.name, :title) || "--"}
username:              #{helper.colorize(model.username, :username) || "--"}
password:              #{helper.colorize(model.password, :password) || "--"}
website:               #{helper.colorize(model.website, :website) || "--"}
tags:                  #{model.tags.map(&:name).join(', ') || "--"}
comment:               #{model.comment.gsub("\n", "\n#{" "*23}") || "--"}
      HEREDOC
    end
  end
end
