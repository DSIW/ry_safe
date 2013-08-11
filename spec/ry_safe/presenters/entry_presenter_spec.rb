require "spec_helper"

describe EntryPresenter do
  subject { EntryPresenter.new(entry) }
  let(:entry) { Safe::Entry.new("Title", Safe::Dir.new("parent")) }

  before do
    entry.username = "Username"
    entry.password = "Password"
    entry.password_confirmation = "Password"
    entry.website = "http://localhost"
    entry.tags = "Tag1,Tag2,Tag3"
    entry.comment = "Comment"
  end

  its(:content) do
    should == <<-STRING
dir:                   /parent
title:                 Title
=======================================
username:              Username
password:              ********
password_confirmation: ********
valid:                 true
website:               http://localhost
tags:                  Tag1, Tag2, Tag3
comment:               Comment
    STRING
  end
end
