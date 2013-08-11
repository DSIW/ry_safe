# encoding: utf-8

require "spec_helper"

describe Import::KeePassXImporter do
  subject { Import::KeePassXImporter.new(fixture("kee_pass_x.xml")) }

  it "should import correctly" do
    pending "Not tested"
  end
end
