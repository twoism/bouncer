$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bouncer'

class Post
  attr_accessor :user_name
  def initialize name
    @user_name = name
  end

  def user
    'Chalmers Hundlebottom'
  end
end

class User
  include Bouncer::GuestList

  can_access :post do
    on :show,   :if => lambda {|post, opts| post.user_name == self.name }
    on :create, :if => lambda {|post, opts| post.user_name =~ /admin/ }
  end

  attr_accessor :name

  def initialize name
    @name = name
  end
end


