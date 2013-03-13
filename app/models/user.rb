class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :phone, :mobile_phone, :address, :role_ids, :organization_id
  # attr_accessible :title, :body
  has_many :roles
  belongs_to :organization

  validates_presence_of :name

  def has_role? (role)
    !roles.where(name: role).first.nil?
  end
end
