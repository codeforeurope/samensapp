class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :phone, :mobile_phone, :address
  # attr_accessible :title, :body
  has_many :roles
  has_many :booking_requests, :foreign_key => :submitter_id
  belongs_to :organization

  validates_presence_of :name, :phone, :address

  def has_role? (role)
    !roles.where(name: role).first.nil?
  end

  def make_silent
    @silent = true
  end

  protected
  def password_required?
    super()  && !@silent
  end
end
