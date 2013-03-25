class User < ActiveRecord::Base
  @create_account = false

  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :phone, :mobile_phone, :address, :create_account
  # attr_accessible :title, :body
  has_many :roles
  has_many :booking_requests, :foreign_key => :submitter_id
  belongs_to :organization

  validates_presence_of :name, :email

  validates_numericality_of [:phone, :mobile_phone], :allow_blank => true
  validates_presence_of [:phone, :address], :if => :is_submitter
  validate :validate_as_submitter

  attr_accessor :submitter_hash
  attr_writer :is_submitter

  def has_role? (role)
    !roles.where(name: role).first.nil?
  end

  def make_silent
    @silent = true
  end

  def is_submitter
    !submitter_hash.nil? || @is_submitter
  end

  protected
  def password_required?
    super() && !@silent
  end

  def create_account
    @create_account
  end

  def create_account=(do_it)
    @create_account = do_it
  end


  def validate_as_submitter
    if persisted? && confirmed?
      if submitter_hash && !submitter_hash[:password].nil? && !submitter_hash[:password_confirmation].nil?
        if !valid_password?(submitter_hash[:password])
          errors.add(:email, :account_exists)
        end
      end
    end
  end
end
