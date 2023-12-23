# Backend Helm Chart

## Introduction

This chart bootstraps a **backend** deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-backend`:

```console
$ helm install --name my-backend charts/backend
```

The command deploys Backend with MongoDB on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-backend` deployment:

```console
$ helm delete my-backend
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the backend chart and their default values.

Parameter | Description | Default
--- | --- | ---
`services.backend.name` | name to use in K8s objects | `backend`
`services.backend.replicaCount` | desired number of backend pods | `1`
`services.backend.image.repository` | backend container image repository | `crypsde/onpk-backend`
`services.backend.image.pullPolicy` | backend container image pull policy | `Always`
`services.backend.image.tag` | backend container image tag | `""`
`services.backend.env` | any additional environment variables to set in the pods | `[<refer to values.yaml>]`
`services.backend.selectorLabels` | labels to apply to Pods and use for selector in `Service` | `{app: backend}`
`services.backend.imagePullSecrets` | name of Secret resource containing private registry credentials | `[]`
`services.backend.podAnnotations` | annotations to be added to pods | `{}`
`services.backend.service.type` | type of backend service to create | `ClusterIP`
`services.backend.service.port` | Sets service port | `9080`
`services.backend.ingress.enabled` | enable an ingress resource | `true` 
`services.backend.ingress.annotations` | additional ingress annotations | `{kubernetes.io/ingress.class: nginx}`
`services.backend.ingress.hosts` | list of ingress hosts | `[ {host: backend.test.com, paths: [{path: /, pathType: ImplementationSpecific}]}]`
`services.backend.ingress.tls` | ingress TLS configuration | `[]`
`mongodb` | MongoDB specific values | `<refer to values.yaml>`
