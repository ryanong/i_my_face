require 'spec_helper'

describe Face do

  before do
    Face.reset!
    Post.reset!
  end

  let(:face) do
    Face.new(
      username: "test",
      first_name: "test"
    )
  end

  describe "#save" do
    it "will presist the data " do
      face.save.should == true
      face.persisted.should == true
      Face.find(face.username).should == face
    end

    it "raises an error if duplicate username is present" do
      face2 = face.clone
      face.save
      expect{ face2.save }.to raise_error
    end
  end

  describe "#enroll" do
    it "will persist a face" do
      face = Face.enroll(
        username: "test",
        first_name: "test"
      )

      Face.find("test").should == face

    end
  end

  describe "#post, #outta_my, #in_my" do
    let(:new_face) do
      Face.new(
        username: "test2",
        first_name: "test2"
      )
    end

    it "posts to all outtas" do
      face.save
      new_face.save
      face.outta_my(new_face)
      post = face.post("hello")

      new_face.posts.include? post
      Face.find("test1") === face
    end

    it "posts to all innas" do
      face.save
      new_face.save
      new_face.in_my(face)

      post = face.post("hello")

      new_face.posts.include? post
    end
  end

  describe "#faced_up" do
    before do
      20.times do |i|
        face = Face.enroll(
          username: "test#{i}",
          first_name: "test#{i}"
        )
        Face.all.values[i-1].outta_my(face) if 1 < i && i < 7

        if 8 < i && i < 13
          Face.all.values[i-1].outta_my(face) 
        end
      end
    end

    it "one link should work" do
      test1 = Face.find("test1")
      test2 = Face.find("test2")
      test1.face_up(test2).should == [test1,test2]
    end

    it "sees if the users are connected" do
      Face.all.values[0].outta_my(Face.all.values[8])
      Face.find('test15').face_up(Face.find('test1')).should be_false
      faced_up = Face.find('test2').face_up(Face.find('test6'))
      faced_up.first.should == Face.find('test2')
      faced_up.last.should == Face.find('test6')
      faced_up.should == Face.all.values[2..6]
      Face.find('test0').face_up(Face.find('test6')).should be_nil
      Face.find('test0').face_up(Face.find('test12')).should == ([Face.all.values[0]] + Face.all.values[8..12])
    end
  end
end
