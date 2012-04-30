require 'set'

class Face
  @@faces = {}
  attr_accessor :username, :first_name, :last_name, :password, :persisted, :outtas, :posts

  def initialize(attributes)
    self.username= attributes[:username]
    self.first_name= attributes[:first_name]
    self.last_name= attributes[:last_name]
    self.password= attributes[:password]
    self.outtas= attributes[:outtas] || Set.new
    self.posts= attributes[:posts] || Set.new
  end

  def save
    if !persisted && @@faces[username]
      raise "Face with #{username} already exists try another username"
    else
      self.persisted= true
      @@faces[username] = self
      true
    end
  end

  def outta_my(face)
    self.outtas << face
    puts "#{self.first_name} outta my faced #{face.first_name}" if DEBUG
  end

  def in_my(face)
    face.outtas << self
  end

  def post(body)
    Post.create(:author => self, :body => body).tap do |post|
      self.posts << post
      self.spread_post(post)
    end
  end

  def spread_post(post)
    self.outtas.each do |user|
      unless user.posts.include? post
        user.posts << post
        puts "#{post.author.first_name}'s post has been posted to #{user.first_name}" if DEBUG
        user.spread_post(post)
      end
    end
  end

  def face_up(faced, visited = [])

    faced = self.class.find(faced) if faced.is_a? String

    return [self] if faced == self

    return nil if self.outtas.size < 1

    self.outtas.to_a.each do |face|
      next if visited.include? face
      visited << face
      if new_chain = face.face_up(faced,visited)
        new_chain.unshift(self)
        return new_chain
      else
        return nil
      end
    end
  end

  def ==(face)
    [:username, :first_name, :last_name, :password, :persisted, :outtas, :posts].each do |key|
      return false if self.send(key) != face.send(key)
    end
    return true
  end

  def inspect
    "#<Face: @username=#{@username}, @first_name=#{@first_name}, @last_name=#{@last_name}>"
  end

  class << self
    def find(username)
      @@faces[username].clone
    end

    alias [] find

    def enroll(options)
      self.new(options).tap do |face|
        face.save
        puts "#{face.first_name} has been enrolled" if DEBUG
      end
    end

    def reset!
      @@faces = {}
    end

    def all
      @@faces
    end
  end
end
