# Helm deployments

## Prerequisite

Because production uses a friendly hostname, it needs to have some additional config to create a LetsEncrypt certificate.  Before deploying to production you need to deploy the certificate.yaml resource using `kubectl apply`

e.g.
```
kubectl -n nomis-api-access-production apply -f certificate.yaml
```

This is resource is linked to a route53 zone that is managed by terraform in the same namespace (see cloudplatform instructions).  The certificate.yaml will create an LetsEncrypt certificate and save it to the kubernetes secret specificed.  The same secret needs to be referenced on the ingress definition (which is defined as one of the variables to the helm Chart, see below)

### Helm init

staging
```
helm init --tiller-namespace nomis-api-access-staging --service-account tiller
```

production
```
helm init --tiller-namespace nomis-api-access-production --service-account tiller
```

### Helm list current releases/deployments
```
helm  --namespace nomis-api-access-staging --tiller-namespace nomis-api-access-staging list
```

### Delete a helm release
```
helm --tiller-namespace nomis-api-access-staging delete [release-name]
```


### Helm deploy app:

Python script method to get secrets from AWS secretmanager, the script using the SDK to download a blob of yaml which is piped into helm.   Helm takes the secrets as stdin and then injects them straight in to deployment, see templates/secrets.yaml to see what values it is expecting for this application.

staging
```
AWS_PROFILE=dev_admin ./get_secrets.py nomis-api-access-staging | helm install nomis-api-access --namespace nomis-api-access-staging --tiller-namespace nomis-api-access-staging  --values - --values=values-staging.yaml
```

production
```
AWS_PROFILE=prod_admin ./get_secrets.py nomis-api-access-production | helm install nomis-api-access  --namespace nomis-api-access-production --tiller-namespace nomis-api-access-production  --values - --values=values-production.yaml
```


Using the AWS CLI method for retreiving secrets from secret manager:

staging
```
AWS_PROFILE=dev_admin aws secretsmanager get-secret-value --secret-id nomis-api-access-staging | jq -r .SecretString | helm install nomis-api-access  --namespace nomis-api-access-staging. --tiller-namespace nomis-api-access-staging  --values - --values=values-staging.yaml
```

### Rolling back a release
Find the revision number for the deployment you want to roll back:
```
helm --tiller-namespace nomis-api-access-staging history nomis-api-access -o yaml
```

Rollback
```
helm --tiller-namespace nomis-api-access-staging rollback nomis-api-access [INSERT REVISION NUMBER HERE] --wait
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

