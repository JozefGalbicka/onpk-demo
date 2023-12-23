# Tekton Pipelines

## Installation
First of all, install dependencies (those contains Tekton itself and requisite Tasks for specified Pipelines as well).

```
$ ./dependencies.sh
```

Then, install the pipelines and run them.
```
# CI
kubectl apply -f vote-app-ci-docker-secret.yaml
kubectl apply -f git-cli-get-tag-task.yaml
kubectl apply -f vote-app-ci.yaml
kubectl apply -f vote-app-ci-run.yaml

kubectl apply -f vote-app-cd-rbac.yaml
kubectl apply -f vote-app-cd.yaml
kubectl apply -f vote-app-cd-run.yaml
```

> Note: please edit the `vote-app-ci-docker-secret.yaml` file, by including `base64` encoded Docker `config.json`.
