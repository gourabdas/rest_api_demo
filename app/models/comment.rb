class Comment < ActiveRecord::Base
	#resourcify
	belongs_to :user
	belongs_to :post

	validates_presence_of :desc
end
