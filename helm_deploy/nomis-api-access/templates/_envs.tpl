{{/* vim: set filetype=mustache: */}}
{{/*
Environment variables for web and worker containers
*/}}
{{- define "nomis-api-access.envs" }}
env:
  - name: RAILS_LOG_TO_STDOUT
    value: 'true'

  - name: DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: nomis-api-access-rds-instance-output 
        key: url

  - name: API_AUTH
    valueFrom:
      secretKeyRef:
        name: {{ template "nomis-api-access.fullname" . }}
        key: API_AUTH

  - name: GOVUK_NOTIFY_API_KEY
    valueFrom:
      secretKeyRef:
        name: {{ template "nomis-api-access.fullname" . }}
        key: GOVUK_NOTIFY_API_KEY

  - name: MOJSSO_URL
    value: https://signon.service.justice.gov.uk

  - name: MOJSSO_ID
    valueFrom:
      secretKeyRef:
        name: {{ template "nomis-api-access.fullname" . }}
        key: MOJSSO_ID

  - name: MOJSSO_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ template "nomis-api-access.fullname" . }}
        key: MOJSSO_SECRET

  - name: RECAPTCHA_SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: {{ template "nomis-api-access.fullname" . }}
        key: RECAPTCHA_SECRET_KEY

  - name: RECAPTCHA_SITE_KEY
    valueFrom:
      secretKeyRef:
        name: {{ template "nomis-api-access.fullname" . }}
        key: RECAPTCHA_SITE_KEY

  - name: SECRET_KEY_BASE
    valueFrom:
      secretKeyRef:
        name: {{ template "nomis-api-access.fullname" . }}
        key: SECRET_KEY_BASE

  - name: NOTIFY_ENABLED
    value: 'true'

  - name: REJECT_ACCESS_REQUEST_TEMPLATE
    value: d39e6478-17d5-4f51-be08-752d413e4633
{{- end -}}
