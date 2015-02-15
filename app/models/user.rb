class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable
  has_many :teams
  has_many :settings
  has_many :notification_subcriptions
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :tasks
  has_many :histories

  mount_uploader :image, ImageUploader
  validates :password, presence: true, length: {minimum: 5, maximum: 120}, on: :create
  validates :password, length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true
  validates :current_password, length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(:name => auth.extra.raw_info.name,
                               :provider => auth.provider,
                                       :uid => auth.uid,
                                          :email => auth.info.email,
                                               :password => Devise.friendly_token[0,20] )
      end
    end
  end
end
