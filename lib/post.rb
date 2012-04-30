require 'set'

class Post
  @@posts = Set.new
  attr_accessor :author, :body, :persisted

  def initialize(options)
    self.author= options[:author]
    self.body= options[:body]
  end

  def index
    @@posts.index(self)
  end

  def save
    puts "saving #{author.first_name}'s post" if DEBUG
    @@posts << self
  end

  class << self
    def create(options)
      self.new(options).tap do |post|
        post.save
      end
    end

    def find(index)
      @@posts[index]
    end

    def all
      @@posts
    end

    def reset!
      @@posts = Set.new
    end
  end
end
