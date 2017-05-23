class LinkHashtag < ActiveRecord::Base
  belongs_to :link
  belongs_to :hashtag
end
