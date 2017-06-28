Feature: Request access token

  Users should be able request tokens for the NOMIS API.
  The form is submitted and can be approved or rejected by admins.

  Background:
    Given the user is on the home page
     Then they should be redirected to the new access request page
      And a link to the NOMIS API documentation should be visble

  Scenario: User completes and submits the access request form
    When the user fills out the form with:
      | field                     | value                 | type   |
      | Requested by              | John Smith            | text   |
      | Contact email             | johnsmith@example.com | text   |
      | Application/service name  | Candies to prisoners  | text   |
      | Reason                    | Some reason           | text   |
      | NOMIS API environment     | prod                  | select |
      | Client public key         | test_client.pub       | file   |
    And submits the form
    Then the user should be redirected to the confirmation page
