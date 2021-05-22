# Description almed4/helm-check-action

#### Based on: igabaydulin/helm-check-action:
[![Version](https://img.shields.io/badge/version-0.2.0-color.svg)](https://github.com/igabaydulin/helm-check-action/releases/tag/0.2.0)

helm-check is a [github action](https://github.com/features/actions) tool which allows to prevalidate helm chart
template before its deployment; executes [helm lint](https://helm.sh/docs/helm/#helm-lint) and [helm package](https://helm.sh/docs/helm/helm_package/)
commands

### Extension

this has been modified by alexandre.meddin@ingka.ikea.com to output packaged helm charts

## Components
* `Dockerfile`: contains docker image configuration
* `entrypoint.sh`: contains executable script for helm templates validation

## Outputs

* `packages`: array of packaged helm charts