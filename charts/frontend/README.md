# Frontend Helm Chart

## Introduction

This chart bootstraps a **frontend** deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Installing the Chart

To install the chart with the release name `my-frontend`:

```console
$ helm install --name my-frontend charts/frontend
```

The command deploys Frontend on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-frontend` deployment:

```console
$ helm delete my-frontend
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the frontend chart and their default values.

Parameter | Description | Default
--- | --- | ---
`services.frontend.name` | name to use in K8s objects | `frontend`
`services.frontend.replicaCount` | desired number of frontend pods | `3`
`services.frontend.image.repository` | frontend container image repository | `crypsde/onpk-frontend`
`services.frontend.image.pullPolicy` | frontend container image pull policy | `Always`
`services.frontend.image.tag` | frontend container image tag | `""`
`services.frontend.env` | any additional environment variables to set in the pods | `[<refer to values.yaml>]`
`services.frontend.selectorLabels` | labels to apply to Pods and use for selector in `Service` | `{app: frontend}`
`services.frontend.imagePullSecrets` | name of Secret resource containing private registry credentials | `[]`
`services.frontend.podAnnotations` | annotations to be added to pods | `{}`
`services.frontend.service.type` | type of frontend service to create | `ClusterIP`
`services.frontend.service.port` | Sets service port | `8080`
`services.frontend.ingress.enabled` | enable an ingress resource | `true` 
`services.frontend.ingress.annotations` | additional ingress annotations | `{kubernetes.io/ingress.class: nginx}`
`services.frontend.ingress.hosts` | list of ingress hosts | `[ {host: frontend.test.com, paths: [{path: /, pathType: ImplementationSpecific}]}]`
`services.frontend.ingress.tls` | ingress TLS configuration | `[]`
`mongodb` | MongoDB specific values | `<refer to values.yaml>`
