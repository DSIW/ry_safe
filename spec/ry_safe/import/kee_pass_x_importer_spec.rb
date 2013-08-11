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
    first_group.name.should == "general"
    first_group.children.size.should == 1

    first_group.children[0].should be_a Safe::Entry
    first_group.children[0].parent.should be first_group
    first_group.children[0].name.should == "website1"
    first_group.children[0].username.should == "username"
    first_group.children[0].password.should == Password.new("123456")
    first_group.children[0].website.should == "https://www.github.com/"
    first_group.children[0].comment.should == "wow\n\nclose"
    first_group.children[0].created_at.should == DateTime.new(2011, 3, 5, 14, 28, 4)
    first_group.children[0].modified_at.should == DateTime.new(2011, 9, 4, 14, 39, 2)


    second_group.should be_a Safe::Dir
    second_group.parent.should be root
    second_group.name.should == "general_2"
    second_group.children.size.should == 7

    second_group.children[0].should be_a Safe::Dir
    second_group.children[0].parent.should be second_group
    second_group.children[0].name.should == "productkeys"
    second_group.children[0].children.size.should == 1

    second_group.children[0].children[0].should be_a Safe::Entry
    second_group.children[0].children[0].parent.should be second_group.children[0]
    second_group.children[0].children[0].name.should == "gh"


    second_group.children[1].should be_a Safe::Entry
    second_group.children[1].parent.should be second_group
    second_group.children[1].name.should == "pc_1"

    second_group.children[2].should be_a Safe::Entry
    second_group.children[2].parent.should be second_group
    second_group.children[2].name.should == "no_name"

    second_group.children[3].should be_a Safe::Entry
    second_group.children[3].parent.should be second_group
    second_group.children[3].name.should == "public_access"

    second_group.children[4].should be_a Safe::Entry
    second_group.children[4].parent.should be second_group
    second_group.children[4].name.should == "public_access_2"

    second_group.children[5].should be_a Safe::Entry
    second_group.children[5].parent.should be second_group
    second_group.children[5].name.should == "public_access_3"

    second_group.children[6].should be_a Safe::Entry
    second_group.children[6].parent.should be second_group
    second_group.children[6].name.should == "no_name_2"
  end
end
