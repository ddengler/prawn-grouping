require File.join(File.expand_path(File.dirname(__FILE__)), "spec_helper")

describe "Prawn::Grouping" do
  it "returns true if the content fits in the current context" do
    pdf = Prawn::Document.new do
      val = group { text "FooBar" }
      (!!val).should == true
    end
  end
end