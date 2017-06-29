require 'mechanize'
require 'jwt'

Given(/^the user is on the home page$/) do
  @agent = Mechanize.new
  @home_page = @agent.get(DOMAIN + '/')
end

Then(/^they should be redirected to the new access request page$/) do
  # FIXME: change title
  expect(@home_page.title).to eq(
    "GOV.UK - The best place to find government services and information"
  )
end

Then(/^a link to the NOMIS API documentation should be visble$/) do
  api_doc_link = @home_page.link_with(:text => 'NOMIS API documentation')
  expect(api_doc_link).not_to be_nil
end

When(/^the user fills out the form with:$/) do |table|
  @form = @home_page.forms.first

  table.symbolic_hashes.each do |hash|
    case hash[:type]
      when 'text'
        text_field = @form.field_with(name: hash[:field])
        if hash[:field] == "access_request[requested_by]"
          @unique_name = hash[:value] + rand(36**10).to_s(36)
          hash[:value] =  @unique_name
        end
        text_field.value = hash[:value]
      when 'select'
        select_list = @form.field_with(name: hash[:field])
        option = select_list.options.select{|o| o.text == hash[:value]}
        select_list.value = option
      when 'file'
        file_upload = @form.file_upload_with(name: hash[:field])
        file_upload.file_name = "#{FIXTURE_FILES_DIR}/#{hash[:value]}"
    end
  end
end

When(/^submits the form$/) do
  @page = @agent.submit(@form)
end


Then(/^the user should be redirected to the confirmation page$/) do
  expect(@page.parser.css('h1').inner_text).to include(
    'Thank you, your request has been accepted and will be reviewed.'
  )
end


When(/^the admin user accesses the admin home page$/) do
  @mojsso_page = @agent.get(DOMAIN + '/admin/')
end

Then(/^the user should be redirected to single sign on$/) do
  if AUTH_ENABLED
    expect(@mojsso_page.title).to include("Ministry of Justice Sign On")
  end
end

When(/^the admin user submits their credentials$/) do
  if AUTH_ENABLED
    login_form = @mojsso_page.forms.first
    login_form.field_with(name: "user[email]").value = MOJSSO_USER
    login_form.field_with(name: "user[password]").value = MOJSSO_PASSWORD
    @admin_home_page = @agent.submit(login_form)
  else
    @admin_home_page = @mojsso_page
  end
end

Then(/^they should authenticate successfully$/) do
  # FIXME: change title
  expect(@admin_home_page.title).to eq("GOV.UK - The best place to find government services and information")
end

And(/^the new access request should be displayed$/) do
  rows = @admin_home_page.css('table tr').select{ |tr|
    tr.element_children.select{ |ec|
      ec.children.first.respond_to?(:content) &&
        ec.children.first.content == @unique_name
    }.first
  }

  expect(rows.count).to eq(1)
  @row = rows.first
end

When(/^the admin user clicks "([^"]*)" on the request$/) do |arg1|
  approve_link = @row.search('a').select{|a| a.text == "Approve" }.first["href"]
  @confirmation_page = @agent.get(DOMAIN + approve_link)
end

Then(/^the confirmation form should be shown$/) do
  # FIXME: change title
  expect(@confirmation_page.title).to eq(
    "GOV.UK - The best place to find government services and information"
  )
end

Then(/^after the admin user adds permissions and clicks "([^"]*)"$/) do |arg1|
  form = @confirmation_page.form_with(action: "/admin/tokens")
  form.field_with(name: "token[permissions]").value = "/nomisapi/404"
  @tokens_page = @agent.submit(form)
end

Then(/^the trackpack link is displayed$/) do
  notice = @tokens_page.css('#notice').inner_text
  match_data = /(http:.*)$/.match notice
  @link = match_data[0]

  expect(@link).not_to be_empty
end

When(/^the user follows the trackback link$/) do
  @token_download_page = @agent.get(@link)
end

Then(/^the download page is active$/) do
  @download_form = @token_download_page.forms.first
  download_button = @download_form.button_with(value: "Download")
  expect(download_button).not_to be_nil
end

When(/^the user clicks the download button$/) do
  @token_file = @agent.submit(@download_form)
  expect(@token_file).not_to be_nil
end

Then(/^a valid token is downloaded$/) do
  decoded_token = JWT.decode(@token_file.body, nil, false).first
  expect(decoded_token["client"]).to eq("Candies to prisoners")
end

And(/^the trackback link is not valid anymore$/) do
  expect{@agent.get(@link)}.to raise_error(
    Mechanize::ResponseCodeError,
    /404 => Net::HTTPNotFound for/
  )
end
