class Post < ActiveRecord::Base
	#resourcify
	has_many :comments, dependent: :destroy
	belongs_to :user

	validates_presence_of :description
end
