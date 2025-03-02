![GitHub](https://img.shields.io/github/license/danielpickens/arctavia) [![Deploy to fly.io app](https://github.com/danielpickens/arctavia/actions/workflows/fly.yaml/badge.svg?branch=main)](https://github.com/danielpickens/arctavia/actions/workflows/fly.yaml) [![Run test suite](https://github.com/danielpickens/arctavia/actions/workflows/test.yaml/badge.svg?branch=main)](https://github.com/danielpickens/arctavia/actions/workflows/test.yaml) 
[![codecov](https://codecov.io/gh/danielpickens/arctavia/branch/main/graph/badge.svg?token=Z3MRFPEI6Q)](https://codecov.io/gh/danielpickens/arctavia)

# Hands On 👋🏼

REST API web application using GO to build infra to terraform for redis operator node.js client. This repository is part of a delivery stack, aiming to simulate an application in production, exploring its automation/improvement points.

<br>

## Requirements

You will need these tools installed on your PC: [docker](https://docs.docker.com/get-docker/) | [docker-compose](https://docs.docker.com/compose/install/) | [helm](https://helm.sh/docs/intro/install/#helm) | [terraform](https://www.terraform.io/downloads) | [gcloud-auth](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke) | [gcloud](https://cloud.google.com/sdk/docs/install)

<br>

## Local APP

| Port      | URI                   | Description            | Method |
| --------- | --------------------- | ---------------------- | ------ |
| :8080     | /                     | Returns Home           | GET    |
| :8080     | /health               | Returns Health         | GET    |
| :8080     | /version              | Returns Version        | GET    |
| :8080     | /accounts             | Returns List Accounts  | GET    |
| :8080     | /accounts/{person_id} | Returns Person Account | GET    |
| :8080     | /accounts             | Insert account         | POST   |
| :8080     | /accounts/{person_id} | Update/Replace account | PUT    |
| :8080     | /accounts/{person_id} | Update/Modify account  | PATCH  |
| :8080     | /accounts/{person_id} | Delete account         | DELETE |

<br>

## Local Docs

| Port      | URI                   | Description            | Method |
| --------- | --------------------- | ---------------------- | ------ |
| :8080     | /swagger/doc.json     | Open Swagger Docs      | GET    |
| :8080     | /swagger/index.html   | Open Swagger Page      | GET    |

<br>

## To provision the local stack using docker run

`make stop && make run`

## To run built-in tests using the local stack provisioned with make run

`make tests`

## To provision the local stack using docker compose (only tests)

`make stop && make dev`

## To run built-in tests using the local stack provisioned with make dev

`make tests`

## To provision the local stack using docker compose (production ready)

`make stop && make prod`

## To run tests, make calls consuming the API

`Examples in structure/calls.tpl`

## Remove stack local

`make stop`

<br>

  Deploy PaaS/Run Test                                                         | Fly APP - PaaS
| ---------------------------------------------------------------------------- | ------------------------ |
| [Page Actions of project](https://github.com/danielpickens/arctavia/actions) | https://appcloud.fly.dev |

<br>

## IAC

First, you should create bucket and export variables you are going to use.

- After accessing the gcp console, create a bucket named poc-from-gke-tf-state. The reference of this bucket is described in the provider.tf file.

- Then export the necessary environment variables to start the configuration process

`export GOOGLE_PROJECT="<YOUR-PROJECT-NAME>" USE_GKE_GCLOUD_AUTH_PLUGIN="True" KUBE_CONFIG_PATH="~/.kube/config"`

Authenticate into Google Cloud console, to so run the following command:

`make terraform-login project_name=<YOUR-PROJECT-NAME>`

Check your project to make sure everything goes well

`make terraform-validation`

Now, we will continue with the creation of the cluster/pools

`make terraform-apply-cluster cluster_name=<YOUR-   CLUSTER-NAME>`

After a few minutes, your infra is ready to be used. It will show you everything that will be created by terraform,
take a moment to check this output. Once you are ready, you just need to run:

`make terraform-apply-pkgs cluster_name=<YOUR-CLUSTER-NAME> project_name=<YOUR-PROJECT-NAME>`

## Cluster/APP info

```
echo "DASH - $(kubectl get svc -n lab-dashboard | awk '{print $4}')"
echo "APP - $(kubectl get svc -n lab-app | awk '{print $4}' | grep -v none)"
```

Once you `port-foward` your services, you can easily access it on your browser via localhost.

```
kubectl port-forward \
    $(kubectl get pods -l=app="kibana" -o name -n lab-logging) 5601 -n lab-logging
kubectl port-forward \
    $(kubectl get pods -l=app.kubernetes.io/instance="monitor" -o name -n lab-monitoring) 3000 -n lab-monitoring
kubectl port-forward \
    $(kubectl get pods -l=app="prometheus" -o name -n lab-monitoring | tail -n1) 9090 -n lab-monitoring
kubectl port-forward \
    $(kubectl get pods -l=app="elasticsearch-master" -o name -n lab-logging) 9200 -n lab-logging
```

## Grafana info

```
kubectl get secret --namespace lab-monitoring grafana -o jsonpath="{.data.admin-user}" | base64 --decode | xargs echo
kubectl get secret --namespace lab-monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode | xargs echo
```

## Kibana filter

To facilitate the understanding of the logs, the following tags were used to view the logs

- kubernetes.container_name
- kubernetes.pod_name
- kubernetes.namespace_name
- log

## Wrapping up
Now, to clean up everything you just need to run

`make terraform-destroy cluster_name=<YOUR-CLUSTER-NAME>`

### Reference

- [Code Organizing](https://github.com/golang-standards/project-layout)
- [API Documentation](https://github.com/swaggo/gin-swagger)
- [Web Framework](https://gin-gonic.com/docs/examples/)
- [Handler Update](https://www.rfc-editor.org/rfc/rfc7396.html)
- [Config Mechanism](https://github.com/spf13/viper)
- [Image Container](https://www.alpinelinux.org/)
- [Mock Suites](https://github.com/stretchr/testify)
- [Application Runtime](https://docs.dapr.io/operations/monitoring/logging/fluentd/)
- [PaaS Deploy](https://fly.io/docs/languages-and-frameworks/golang/)
- [Test Coverage](https://docs.codecov.com/docs/github-tutorial)
- [SQL Compiler](https://docs.sqlc.dev/en/latest/tutorials/getting-started-postgresql.html)
- [SQL Driver](https://github.com/lib/pq)
- [Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)
- [Certificates](https://cert-manager.io/docs/getting-started/)
- [K8S Cluster](https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke)
- [PKGS Manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
- [Logs Stack](https://techcommunity.microsoft.com/t5/core-infrastructure-and-security/getting-started-with-logging-using-efk-on-kubernetes/ba-p/1333050)
- [Observability](https://grafana.com/docs/grafana/latest/getting-started/get-started-grafana-prometheus/)
