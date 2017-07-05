class User < ActiveRecord::Base
  # include Tire::Model::Search
  # include Tire::Model::Callbacks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # geocoded_by :address   # can also be an IP address
  # after_validation :geocode
  # reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode  # auto-fetch address

  has_many :posts, :dependent => :destroy
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  validates_presence_of :first_name, :last_name, :age
  validates :age, :numericality => { :greater_than_or_equal_to => 0 }

  def add_friend(friend)
    friendship = friendships.build(friend_id: friend.id)
    friendship.save
  end

  def remove_friend(friend)
    friendship = friendships.find_by(friend_id: friend.id)
    friendship.destroy
  end

  def full_name
    self.first_name + " " + self.last_name
  end

  def is_owner?(post)
    self.id == post.user_id
  end

  def all_friends
    list = friends
    list + inverse_friends
  end

  def get_feed
    ids = all_friends.map(&:id)
    ids << self.id
    Post.where(user_id: ids)
  end

  def is_friend?(user)
    all_friends.include? user
  end
end
