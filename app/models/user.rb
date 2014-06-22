class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :teams
  has_many :settings
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :tasks
  has_many :histories

  mount_uploader :image, ImageUploader
  validates :password, presence: true, length: {minimum: 5, maximum: 120}, on: :create
  validates :password, length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true
  validates :current_password,length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true
end
