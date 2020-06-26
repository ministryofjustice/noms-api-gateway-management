# Helm deployments

## Prerequisite

Ensure the certificate definition exists in the cloud-platform-environments repo under the relevant namespaces folder

e.g.
```
cloud-platform-environments/namespaces/live-1.cloud-platform.service.justice.gov.uk/[INSERT NAMESPACE NAME]/05-certificate.yaml
```

This is resource is linked to a route53 zone that is managed by terraform in the same namespace (see cloudplatform instructions).  The certificate.yaml will create an LetsEncrypt certificate and save it to the kubernetes secret specificed.  The same secret needs to be referenced on the ingress definition (which is defined as one of the variables to the helm Chart, see below)


### Helm deploy app:

staging
```
AWS_PROFILE=dev_admin aws secretsmanager get-secret-value --secret-id nomis-api-access-staging | jq -r .SecretString | helm upgrade calico-arachnid nomis-api-access --install --namespace nomis-api-access-staging --values - --values=values-staging.yaml
```

production
```
AWS_PROFILE=prod_admin aws secretsmanager get-secret-value --secret-id nomis-api-access-production | jq -r .SecretString | helm upgrade hasty-porcupine nomis-api-access --install --namespace nomis-api-access-production --values - --values=values-production.yaml
```

### Managing secrets

Secrets can be managed from the AWS console, or from the AWS CLI.  Essentially we are storing blob of yaml inside AWS secretmanager.  It is possible to versions for secrets too.  Here's a few ideas:

Create a secret from a yaml file stored locally, see secrets-example.yaml
```
AWS_PROFILE=dev_admin aws secretsmanager create-secret --name test2 --secret-string "$(cat secrets-example.yaml)"
```

Update an existing secret:
First download it and save it:
```
AWS_PROFILE=dev_admin aws secretsmanager get-secret-value --secret-id nomis-api-access-staging > secrets-temp.yaml
```
Then edit the file just created,  updating the secrets as neeed.  We then upload to AWS secret manager:
```
AWS_PROFILE=dev_admin aws secretsmanager update-secret --secret-id nomis-api-access-staging --secret-string "$(cat secrets-temp.yaml)"
```
NOTE: Ensure you have deleted `secrets-temp.yaml` file after you have finished working. 

# DB rake tasks

E.g.
```
kubectl -n nomis-api-access-staging exec [pod_name] -- bundle exec rake db:migrate
```


# Connect to DB using PSQL

Get the DB connection creds
```
kubectl -n nomis-api-access-staging get secret nomis-api-access-staging-rds-instance-output -o json | jq -r .data.url | base64 -D
```

Run a simple port forward pod
```
kubectl -n nomis-api-access-staging run port-forward --generator=run-pod/v1 --image=umaar/simple-port-forward --port=5432 --env="REMOTE_HOST=cloud-platform-3be904e3e369a543.cdwm328dlye6.eu-west-2.rds.amazonaws.com" --env="REMOTE_PORT=5432"
```

Port forward
```
kubectl -n nomis-api-access-staging  port-forward port-forward 5432:1025
```

Connect with psql (using creds retreived above)
```
psql -h 127.0.0.1 -U[username] -d [database]
```

