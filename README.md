[![Build Status](https://travis-ci.org/ministryofjustice/noms-api-gateway-management.svg?branch=master)](https://travis-ci.org/ministryofjustice/noms-api-gateway-management)

# NOMS API Gateway Management
### AKA "NOMS API Access"

Admin/management tool for the [NOMS API Gateway](https://github.com/ministryofjustice/noms-api-gateway). Facilitates the provisioning, tracking and revocation of client tokens for the NOMIS API.

External users/client can submit requests to access the NOMIS API.

Provides an endpoint ```/api/tokens/revoked``` which is polled by the API Gateway to handle revoked tokens.

Uses [GOV.UK Notify](https://www.gov.uk/government/publications/govuk-notify/govuk-notify) to send notifications.

### Dependencies

* PostgreSQL

* GOV.UK Notify account with templates set up for:

  * Team notification email when access request submitted.
  * Token creation email for users, with trackback link to provision token.
  * See [Notify service](https://github.com/ministryofjustice/noms-api-gateway-management/blob/master/app/services/notify.rb) for required template params.

* MOJ Sign-on

The admin controllers are secured with [moj-signon](https://github.com/ministryofjustice/moj-signon)

This integration requires some environment variables (see 'Environment variables' below).
Users must have the 'admin' role to gain access to any admin controller methods.

### Environment variables

    GOVUK_NOTIFY_API_KEY - API key for Notify
    ACCESS_REQUEST_NOTIFICATION_TEMPLATE - access request template ID
    TOKEN_TRACKBACK_TEMPLATE - token creation template ID
    TEAM_EMAIL - email address of the product/support team
    API_AUTH - shared secret used to authenticate against the /api/tokens/revoked endpoint
    MOJSSO_ID - Client ID in the moj-signon service
    MOJSSO_SECRET - Secret associated with the app in the moj-signon service
    MOJSSO_URL - Full URL at which the moj-signon service can be found
    AUTH_ENABLED - Enable/Disable MOJ SSO authentication - Default "true"
    NOTIFY_ENABLED - Enable/Disable email notifications via Notify - Default "true"

### Set up and run

Development seed data is provided in [db/seeds.rb](https://github.com/ministryofjustice/noms-api-gateway-management/blob/master/db/seeds.rb) to create dummy provisioning keys for each of the API environment (dev, preprod, and prod).

    rake db:create db:migrate db:seed
    rails s

### Tests

#### Unit tests

Test all features and regressions locally.

Requirements:

* Local postgres database
* Ruby environment including all gems

Run with : `bundle exec rspec`

#### Acceptance tests

Test main features agains a running external environment.

### Importing existing tokens

There is a rake task in [lib/tasks/import.rake](https://github.com/ministryofjustice/noms-api-gateway-management/lib/tasks/import.rake) to import tokens from a CSV file. The column mappings were based around the existing [Google spreadsheet of tokens](https://docs.google.com/spreadsheets/d/1PJHdykrJ1e7nsm0_07vksy6DbVLzjwHuDAkbwt88y3Q/edit#gid=0) - if you need to change them, you can alter the *mapped_csv_values* method in [app/models/imported_token_builder.rb](https://github.com/ministryofjustice/noms-api-gateway-management/app/models/imported_token_builder.rb)

To run the task:

    rake import:tokens FILE=/path/to/the/csv/file/here

The import is surrounded in a transaction - either all the rows import successfully, or the whole operation rolls back and no changes are made.


### Disable authentication

Requirements:

* Running external environment with notifications disabled
* Ruby environment including all gems

Configuration:

    DOMAIN_UNDER_TEST - URL of remote application - Default http://localhost:3000
    MOJSSO_USER - Registered MOJ SSO user
    MOJSSO_PASSWORD - Password for user above
    AUTH_ENABLED - Enable/Disable authentication on client side - Default "true"

Run with `bundle exec cucumber`
