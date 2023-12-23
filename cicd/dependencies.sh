#!/bin/bash

### Install Tekton ###
# https://tekton.dev/docs/installation/pipelines/
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

### Task dependencies ###
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/kaniko/0.6/kaniko.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.9/git-clone.yaml
kubectl apply -f https://api.hub.tekton.dev/v1/resource/tekton/task/helm-upgrade-from-source/0.3/raw
