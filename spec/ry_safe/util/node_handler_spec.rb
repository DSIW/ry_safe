# encoding: utf-8

require "spec_helper"

describe Util::NodeHandler do
  include Util

  describe "::copy" do
    let(:root) { Safe::Dir.new("Root") }
    let(:node1) { Safe::Node.new("N1") }
    let(:dir1) { Safe::Dir.new("D1") }
    let(:dir2) { Safe::Dir.new("D2") }
    let(:d2n1) { Safe::Node.new("N1") }

    before do
      root << node1
      root << dir1
      dir2 << d2n1
      root << dir2
      # N1
      # D1
      # D2 < D2N1
    end

    it "should not be possible to remove root node" do
      expect { Util::NodeHandler.copy(root, Safe::Dir.new("new_dir")) }.to raise_error Error::NotCopyable
    end

    it "should raise if source is not of type Node" do
      expect { Util::NodeHandler.copy(Array.new, Safe::Node.new("new_node")) }.to raise_error Error::SourceNotNode
    end

    it "should raise if destination is no Dir" do
      expect { Util::NodeHandler.copy(node1, Safe::Node.new("new_node")) }.to raise_error Error::DestinationNotNode
    end

    it "should copy node1" do
      copied_node = Util::NodeHandler.copy(node1, root)
      root.should have(4).children
      root.should include copied_node
      node1.should == copied_node
      node1.should_not be copied_node
    end

    it "should copy dir without children" do
      copied_dir = Util::NodeHandler.copy(dir1, root)
      root.should have(4).children
      root.should include copied_dir
      dir1.should == copied_dir
      dir1.should_not be copied_dir
    end

    it "should copy dir with children" do
      copied_dir = Util::NodeHandler.copy(dir2, root)
      root.should have(4).children
      root.should include copied_dir
      dir2.should == copied_dir
      dir2.should_not be copied_dir

      # children are copied
      dir2.children.should == copied_dir.children
      dir2.size.should == copied_dir.size
      dir2.children.should_not be copied_dir.children

      new_node = Safe::Node.new("new_node")
      dir2 << new_node
      copied_dir.should_not include new_node
    end
  end

  describe "::remove" do
    let(:root) { Safe::Dir.new("Root") }
    let(:node1) { Safe::Node.new("N1") }
    let(:dir1) { Safe::Dir.new("D1") }
    let(:node2) { Safe::Node.new("N2") }

    before do
      root << node1
      dir1 << node2
      root << dir1
    end

    it "should not be possible to remove root node" do
      expect { Util::NodeHandler.remove(root) }.to raise_error Error::NotRemovable
    end

    it "should raise if node is not of type Node" do
      expect { Util::NodeHandler.remove(Array.new) }.to raise_error Error::NotNode
    end

    context "parent is node" do
      it "should remove link to parent" do
        removed_node = Util::NodeHandler.remove(node1)
        removed_node.parent.should be_nil
      end
    end

    context "parent is dir" do
      it "should remove link to parent and remove node from children collection" do
        removed_node = Util::NodeHandler.remove(node2)
        removed_node.parent.should be_nil

        dir1.should_not include removed_node
        removed_node.should be_frozen
      end
    end
  end

  describe "::move" do
    let(:root) { Safe::Dir.new("Root") }
    let(:node1) { Safe::Node.new("N1") }
    let(:dir1) { Safe::Dir.new("D1") }
    let(:dir2) { Safe::Dir.new("D2") }
    let(:d2n1) { Safe::Node.new("N1") }

    before do
      root << node1
      root << dir1
      dir2 << d2n1
      root << dir2
    end

    it "should not be possible to move root node" do
      expect { Util::NodeHandler.move(root, Safe::Dir.new("new_dir")) }.to raise_error Error::NotMovable
    end

    it "should move dir2 from root to dir1" do
      Util::NodeHandler.move(dir2, dir1)
      root.should have(2).children
      root.should_not include dir2
      dir2.parent.should be dir1
    end
  end
end
