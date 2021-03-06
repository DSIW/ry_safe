require "spec_helper"

describe EntryPresenter do
  subject { EntryPresenter.new(entry) }
  let(:entry) { Safe::Entry.new("Title", Safe::Dir.new("parent")) }

  before do
    entry.username = "Username"
    entry.password = "Password "
    entry.website = "http://localhost"
    entry.tags = "Tag1,Tag2,Tag3"
    entry.comment = "Comment\nIt's OK"
  end

  its(:content) do
    should == <<-STRING
dir:                   /parent
title:                 Title
username:              Username
password:              *********
website:               http://localhost
tags:                  Tag1, Tag2, Tag3
comment:               Comment
                       It's OK
    STRING
  end

  context "with visible passwords" do
    before { Password.visible! }

    its(:content) do
      should == <<-STRING
dir:                   /parent
title:                 Title
username:              Username
password:              'Password '
website:               http://localhost
tags:                  Tag1, Tag2, Tag3
comment:               Comment
                       It's OK
      STRING
    end
  end
end
