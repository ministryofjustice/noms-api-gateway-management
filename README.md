[![Build Status](https://travis-ci.org/ministryofjustice/noms-api-gateway-management.svg?branch=master)](https://travis-ci.org/ministryofjustice/noms-api-gateway-management)

# NOMS API Gateway Management

Admin/management tool for the [NOMS API Gateway](https://github.com/ministryofjustice/noms-api-gateway). Facilitates the provisioning, tracking and revocation of client tokens for the NOMIS API.

External users/client can submit requests to access the NOMIS API.

Provides an endpoint ```/api/tokens/revoked``` which is polled by the API Gateway to handle revoked tokens.

Uses [GOV.UK Notify](https://www.gov.uk/government/publications/govuk-notify/govuk-notify) to send notifications.

### Dependencies

PostgreSQL

GOV.UK Notify account with templates set up for:

Team notification email when access request submitted.
Token creation email for users, with trackback link to provision token.

See [Notify service](https://github.com/ministryofjustice/noms-api-gateway-management/blob/master/app/services/notify.rb) for required template params.

MOJ Sign-on

The admin controllers are secured with [moj-signon](https://github.com/ministryofjustice/moj-signon)
This integration requires some environment variables (see 'Environment variables' below).
Users must have the 'admin' role to gain access to any admin controller methods.

### Environment variables

    GOVUK_NOTIFY_API_KEY - API key for Notify
    ACCESS_REQUEST_NOTIFICATION_TEMPLATE - access request template id
    TOKEN_TRACKBACK_TEMPLATE - token creation template it
    TEAM_EMAIL - email address of the product/support team
    API_AUTH - shared secret used to authenticate against the /api/tokens/revoked endpoint
    MOJSSO_ID - Client ID in the moj-signon service
    MOJSSO_SECRET - Secret associated with the app in the moj-signon service
    MOJSSO_URL - Full URL at which the moj-signon service can be found

### Set up and run

Development seed data is provided in [db/seeds.rb](https://github.com/ministryofjustice/noms-api-gateway-management/blob/master/db/seeds.rb) to create dummy provisioning keys for each of the API environment (dev, preprod, and prod).

    rake db:create db:migrate db:seed
    rails s

### Disable authentication

It is possible to disable authentication for testing:

```
$ AUTH_ENABLED=false rails s
...
[WARN] MOJSSO_ID/MOJSSO_SECRET/MOJSSO_URL not configured
```
