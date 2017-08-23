Feature: Request access token

  Users should be able request tokens for the NOMIS API.
  The form is submitted and can be approved or rejected by admins.

  Background:
    Given the user is on the home page
     Then they should be redirected to the new access request page
      And a link to the NOMIS API documentation should be visble

  Scenario: User completes and submits the access request form
    When the user fills out the form with:
      | field                               | value                 | type   |
      | access_request[requested_by]        | John Smith            | text   |
      | access_request[contact_email]       | johnsmith@example.com | text   |
      | access_request[service_name]        | Candies to prisoners  | text   |
      | access_request[reason]              | Some reason           | text   |
      | access_request[environment_id]      | prod                  | select |
      | access_request[client_pub_key_file] | test_client.pub       | file   |
    And submits the form
    Then the user should be redirected to the confirmation page

    When the admin user accesses the admin home page
    Then the user should be redirected to single sign on

    When the admin user submits their credentials
    Then they should authenticate successfully
    And the new access request should be displayed

    When the admin user clicks "Approve" on the request
    Then the confirmation form should be shown
    And  after the admin user adds permissions and clicks "Approve"
    Then the trackpack link is displayed

    When the user follows the trackback link
    Then the download page is active

    When the user clicks the download button
    Then a valid token is downloaded
    And  the trackback link is not valid anymore
