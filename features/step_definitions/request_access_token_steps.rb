ActiveSupport::TestCase.file_fixture_path = "#{Rails.root}/spec/fixtures/files"

Given(/^the user is on the home page$/) do
  visit(root_url)
end

Then(/^they should be redirected to the new access request page$/) do
  expect(page).to have_content('Request access token')
end

Then(/^a link to the NOMIS API documentation should be visble$/) do
  expect(page.find_link('NOMIS API documentation')).to be_visible
end

When(/^the user fills out the form with:$/) do |table|
  regexes = {
    "regex1" => "^\/nomisapi\/health$\n^\/nomisapi\/lookup/active_offender?date_of_birth=[\d-]+&noms_id=[\w]+$"
  }

  data = table.rows_hash
  fill_in "Requested by", with: data["Requested by"]
  fill_in "Contact email", with: data["Contact email"]
  fill_in "Application/service name", with: data["Application/service name"]
  fill_in "Reason", with: regexes[data["Reason"]]
  select data["NOMIS API environment"], from: "NOMIS API environment"
  attach_file "Client public key", "#{Rails.root}/spec/fixtures/files/#{data["Client public key"]}"

  click_button 'Submit'
end
