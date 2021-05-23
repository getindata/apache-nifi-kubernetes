# Apache NiFi and NiFi Registry on Kubernetes

It is a repository with Helm charts for Apache NiFi and Apache NiFi Registry.

## Prerequisites

You need the following components to use these Helm charts:

- Kubernetes cluster (1.15 and newer)
- Helm 3

Tested with the following Ingress:
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
Here we use features [SSL Passthrough](https://kubernetes.github.io/ingress-nginx/user-guide/tls/#ssl-passthrough).

## Tests

You can find CI pipelines for two CICD tools: GitLab CI and GitHub Actions.

- GitLab CI: .gitlab-ci.yml
- GitHub Actions: directory .github/workflows

## Installation

## Configuration

## Credits

Inspired from https://github.com/cetic/helm-nifi
