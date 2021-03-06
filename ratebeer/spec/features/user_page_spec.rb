require "spec_helper"

describe "User" do
	let(:style){ FactoryGirl.create(:style) }
	before :each do
		@user=FactoryGirl.create(:user)
		visit signin_path
    	fill_in('username', :with => 'Pekka')
    	fill_in('password', :with => 'Foobar1')
    	click_button('Log in')
    	@brewery=FactoryGirl.create(:brewery)
		@beer=FactoryGirl.create(:beer, style: style, brewery: @brewery)
		@rating=FactoryGirl.create(:rating, user: @user, beer: @beer, score: 10)
	end
	it "has ratings showing on his page" do
		# Doesn't have other user's ratings
		user2=FactoryGirl.create(:user, username: "Simo", password: "Foobar1")
		FactoryGirl.create(:rating, user: user2, score: 20, beer: @beer)
		visit user_path(@user)
		expect(page).to have_content("Kalja 10")
		# Should not have content "Kalja 20"
		expect(page).to  have_no_content("Kalja 20")
	end
	it "can add a beer" do
		visit new_beer_path
		fill_in("beer[name]", with: "Kalja")
		select("Bisse", from: "beer[style_id]")
		select("Kaljala", from: "beer[brewery_id]")
		click_button("Save")
		expect(Beer.all.count).to be(2)
	end
	it "can destroy review" do
		visit user_path(@user)
		expect(page).to have_content("delete")
		expect(@user.ratings.count).to be(1)
		click_link("delete")
		expect(@user.ratings.count).to be(0)
	end
	it "has correct favorite brewery" do
		@user.favorite_brewery.name.should=="Kaljala"
		visit user_path(@user)
		expect(page).to have_content("Kaljala")
	end
	it "has correct favorite style" do
		visit user_path(@user)
		expect(page).to have_content("Bisse")
	end
end