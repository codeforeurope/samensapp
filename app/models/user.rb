class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :phone, :mobile_phone, :address, :create_account
  # attr_accessible :title, :body
  has_many :roles
  has_many :booking_requests, :foreign_key => :submitter_id
  has_many :organizations, :through => :roles, :source => :authorizable, :source_type => 'Organization', :uniq => true
  attr_accessor :create_account, :is_submitter
  has_many :authorizations

  validates_presence_of :name, :email

  validates_numericality_of [:phone, :mobile_phone], :allow_blank => true
  validates_presence_of [:phone, :address], :if => :is_submitter
  validate :validate_as_submitter


  def role? (name, resource = nil)
    if resource.nil?
      !roles.where(:name => name, :authorizable_type => nil, :authorizable_id => nil).empty?
    else
      if resource.class.name == :class.to_s.camelize
        !roles.where(:name => name, :authorizable_type => resource.to_s).empty?
      else
        !roles.where(:name => name, :authorizable_type => resource.class.name, :authorizable_id => resource.id).empty?
      end
    end
  end
  def self.from_omniauth(auth)
    authorization = Authorization.where(auth.slice(:provider, :uid)).first
    if authorization.nil?
      user = where(:email => auth[:info][:email]).first_or_initialize
    else
      user = authorization.user
    end
    if user.persisted?
      if authorization.nil?
        user.authorizations.build auth.slice(:provider, :uid).merge auth[:credentials].slice(:token, :expires_at)

        user.save
      else
        authorization.update_attributes auth[:credentials].slice(:token, :expires_at)
      end
    end
    user
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  protected
  def password_required?
    !create_account.to_i.zero? || (super() && !(is_submitter && attribute(:password).nil? && attribute(:password_confirmation).nil?))
  end


  def validate_as_submitter
    if errors.empty?
      #if persisted? && confirmed?
      #  if is_submitter && !submitter_hash[:password].nil? && !submitter_hash[:password_confirmation].nil?
      #
      #    if !valid_password?(submitter_hash[:password])
      #      errors.add(:email, :account_exists)
      #    end
      #  end
      #end
    else

    end

  end
end
