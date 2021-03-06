class Membership < ActiveRecord::Base
  attr_accessible :user_id, :beer_club_id, :confirmed
  belongs_to :user
  belongs_to :beer_club
  validates_presence_of :user_id
  validates_presence_of :beer_club_id
  validates_uniqueness_of :user_id, scope: :beer_club_id
end
