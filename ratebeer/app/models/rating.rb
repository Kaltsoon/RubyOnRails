class Rating < ActiveRecord::Base
  attr_accessible :beer_id, :score
  belongs_to :beer
  belongs_to :user
  def to_s
  	Beer.find(beer_id).name+" "+score.to_s
  end
end