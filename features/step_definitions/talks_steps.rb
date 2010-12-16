When /^I add a talk$/ do
  visit new_my_talk_path
  @talk = Factory.build(:talk)
  fill_in :title, :with => @talk.title
  fill_in :description, :with => @talk.description
  fill_in "Slides url", :with => @talk.slides_url
  click_button "Add"
  And %Q{I should be redirected}
end

Then /^the talk should be added$/ do
  profile = User.find(@user.id).profile
  profile.talks.select{ |t| t.title == @talk.title }.first.should_not be_nil
end

Given /^I have a talk$/ do
  @talk = Factory.build(:talk)
  profile = User.find(@user.id).profile
  profile.talks << @talk
  @talk.save
  profile.save
end

When /^I add a presentation for that talk$/ do
  visit new_my_talk_presentation_path(@talk)
  @presentation = Factory.build(:presentation)
  fill_in :presentation_date, :with => @presentation.presentation_date
  click_button "Add"
  And %Q{I should be redirected}
end

Then /^the presentation should be added$/ do
  profile = User.find(@user.id).profile
  profile.presentations.select{ |p| p.talk == profile.talks.first }.first.should_not be_nil
end