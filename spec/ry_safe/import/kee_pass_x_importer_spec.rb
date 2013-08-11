# encoding: utf-8

require "spec_helper"

describe Import::KeePassXImporter do
  subject { Import::KeePassXImporter.new(fixture("kee_pass_x.xml")) }

  def root
    Safe::Tree.root
  end

  def first_group
    root.children[0]
  end

  def second_group
    root.children[1]
  end

  it "should import correctly" do
    subject.import

    first_group.should be_a Safe::Dir
    first_group.parent.should be root
    first_group.name.should == "General"
    first_group.children.size.should == 1

    first_group.children[0].should be_a Safe::Entry
    first_group.children[0].parent.should be first_group
    first_group.children[0].name.should == "Website1"
    first_group.children[0].username.should == "username"
    first_group.children[0].password.should == Password.new("123456")
    first_group.children[0].website.should == "https://www.github.com/"
    first_group.children[0].comment.should == "Comment"


    second_group.should be_a Safe::Dir
    second_group.parent.should be root
    second_group.name.should == "WWW"
    second_group.children.size.should == 4

    second_group.children[0].should be_a Safe::Dir
    second_group.children[0].parent.should be second_group
    second_group.children[0].name.should == "Productkeys"
    second_group.children[0].children.size.should == 1

    second_group.children[0].children[0].should be_a Safe::Entry
    second_group.children[0].children[0].parent.should be second_group.children[0]
    second_group.children[0].children[0].name.should == "GH"


    second_group.children[1].should be_a Safe::Entry
    second_group.children[1].parent.should be second_group
    second_group.children[1].name.should == "PC 1"

    second_group.children[2].should be_a Safe::Entry
    second_group.children[2].parent.should be second_group
    second_group.children[2].name.should == "--"

    second_group.children[3].should be_a Safe::Entry
    second_group.children[3].parent.should be second_group
    second_group.children[3].name.should == "Public Access"
  end
end
