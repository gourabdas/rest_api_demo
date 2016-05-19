class User < ActiveRecord::Base
  # in order to make it authenticatable using token to the user
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
   has_many :posts, dependent: :destroy
   has_many :comments, dependent: :destroy

  # User::Roles
  # The available roles
  Roles = [ :admin , :guest, :user ]

  def is?( requested_role )
    self.role == requested_role.to_s
  end
end
