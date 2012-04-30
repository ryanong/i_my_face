require "spec_helper"

describe Post do

  before do
    Post.reset!
  end

  describe "#save" do
    it "will save a new post" do
      Post.create({})
      Post.all.size.should == 1
      Post.all.first.save
      Post.all.size.should == 1
    end
  end
end
