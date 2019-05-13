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

* Google reCaptcha

Protection against DDoS and bots on the user facing access request form is provided by a CAPTCHA using [Google's service](https://www.google.com/recaptcha/intro/).

### Environment variables

|name                                   |purpose                                           |default|test        |run locally   |
|---------------------------------------|--------------------------------------------------|-------|------------|--------------|
|AUTH_ENABLED                           |Enable/disable MOJ SSO authentication             |true   |true        |false         |
|NOTIFY_ENABLED                         |Enable/disable email notifications                |true   |false       |false         |
|RECAPTCHA_ENABLED                      |Enable/Disable reCAPTCHA                          |true   |false       |false         |
|MOJSSO_ID                              |Client ID in the moj-signon service               |-      |foobar      |-             |
|MOJSSO_SECRET                          |Application secret in the moj-signon service      |-      |foobar      |-             |
|ACCESS_REQUEST_MAX_REQUESTS_PER_MINUTE |Max requests to the access request form per minute|6|6|6|
|MOJSSO_URL                             |Full URL at which the moj-signon service can be found|-|-|-|
|GOVUK_NOTIFY_API_KEY                   |API key for Notify|-|-|-|
|API_AUTH                               |shared secret used to authenticate against the /api/tokens/revoked endpoint|-|-|-|
|ACCESS_REQUEST_NOTIFICATION_TEMPLATE   |access request template ID|-|-|-|
|TOKEN_TRACKBACK_TEMPLATE               |token creation template ID|-|-|-|
|REJECT_ACCESS_REQUEST_TEMPLATE         |access request rejection template ID|-|-|-|
|TEAM_EMAIL                             |email address of the product/support team|-|-|-|
|RECAPTCHA_SITE_KEY                     |Google reCAPTCHA key|-|-|-|
|RECAPTCHA_SECRET_KEY                   |Google reCAPTCHA secret|-|-|-|

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

Test main features against a running external environment.

Requirements:

* Running external environment with notifications disabled
* Ruby environment including all gems

Configuration:

    DOMAIN_UNDER_TEST - URL of remote application - Default http://localhost:3000
    MOJSSO_USER - Registered MOJ SSO user
    MOJSSO_PASSWORD - Password for user above
    AUTH_ENABLED - Enable/Disable authentication on client side - Default "true"

Run with `bundle exec cucumber`

### Importing existing tokens

There is a rake task in [lib/tasks/import.rake](https://github.com/ministryofjustice/noms-api-gateway-management/lib/tasks/import.rake) to import tokens from a CSV file. The column mappings were based around the existing [Google spreadsheet of tokens](https://docs.google.com/spreadsheets/d/1PJHdykrJ1e7nsm0_07vksy6DbVLzjwHuDAkbwt88y3Q/edit#gid=0) - if you need to change them, you can alter the *mapped_csv_values* method in [app/models/imported_token_builder.rb](https://github.com/ministryofjustice/noms-api-gateway-management/app/models/imported_token_builder.rb)

To run the task:

    rake import:tokens FILE=/path/to/the/csv/file/here

The import is surrounded in a transaction - either all the rows import successfully, or the whole operation rolls back and no changes are made.

## Docker Build:

This app runs in MoJ cloudplatform, you will need to get familiar with the setup there:

https://user-guide.cloud-platform.service.justice.gov.uk/#cloud-platform-user-guide

### Build image and tag
```
docker build -t  nomis-api-access:latest .
docker tag nomis-api-access:latest 754256621582.dkr.ecr.eu-west-2.amazonaws.com/digital-prison-services/nomis-api-access-staging:latest
```

Ensure you've setup an AWS profile for the MoJ cloudplatform namespace this app uses, this will allow you run this command to fectch the login creds for the image repo in AWS, when then allows you login and push the newly build image:
```
export AWS_PROFILE=nomis-api-access-staging
$(aws ecr get-login --no-include-email --region eu-west-2)
```

Docker push
```
docker push 754256621582.dkr.ecr.eu-west-2.amazonaws.com/digital-prison-services/nomis-api-access-staging:latest
```

.... similar process for pushing to production AWS ecr repo.
```
export AWS_PROFILE=nomis-api-access-production
$(aws ecr get-login --no-include-email --region eu-west-2)
docker tag nomis-api-access:latest 754256621582.dkr.ecr.eu-west-2.amazonaws.com/digital-prison-services/nomis-api-access-production:v1.0

docker push 754256621582.dkr.ecr.eu-west-2.amazonaws.com/digital-prison-services/nomis-api-access-production:v1.0
```
