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
  table.symbolic_hashes.each do |hash|
    case hash[:type]
      when 'text'
        fill_in hash[:field], with: hash[:value]
      when 'select'
        select hash[:value], from: hash[:field]
      when 'file'
        attach_file hash[:field], "#{Rails.root}/spec/fixtures/files/#{hash[:value]}"
    end
  end
end

When(/^submits the form$/) do
  click_button 'Submit'
end

Then(/^the user should be redirected to the confirmation page$/) do
  expect(current_url).to eq(access_request_confirmation_url)
end
