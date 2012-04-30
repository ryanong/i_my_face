require 'spec_helper'
DEBUG = true
describe Import do
  before do
    Face.reset!
  end
  describe ".faces" do
    it "adds all the users from the given file" do
      Import.faces("data/data1_faces__small-no-cycles.dat")
      face = Face.find("ABuyanskyy1")
      face.first_name.should == "Alexei"
      face.last_name.should == "Buyanskyy"
    end
  end

  describe ".connections" do
    it "correctly connects users" do
      Import.faces("data/data1_faces__small-no-cycles.dat")
      Import.connections("data/data1_connections__small-no-cycles.dat")
      ab = Face.find('ABuyanskyy1')
      am = Face.find('AMonahan1')
      am.face_up(ab).should == [am,ab]
    end
  end

  describe ".posts" do
    it "correctly posts to users" do
      Import.faces("data/data1_faces__small-no-cycles.dat")
      Import.connections("data/data1_connections__small-no-cycles.dat")
      Import.posts("data/data1_posts__small-no-cycles.dat")
      Post.all.size.should == `wc -l data/data1_posts__small-no-cycles.dat `.to_i 
    end
  end
end
