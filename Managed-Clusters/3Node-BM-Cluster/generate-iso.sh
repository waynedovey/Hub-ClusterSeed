#!/bin/bash

oc apply -k .

kubectl -n test-cluster get clusterdeployments.hive.openshift.io test-cluster -o=jsonpath="{.metadata.name}{'\n'}{range .status.conditions[*]}{.type}{'\t'}{.message}{'\n'}"

kubectl -n test-cluster get agentclusterinstalls.extensions.hive.openshift.io test-cluster -o=jsonpath="{.metadata.name}{'\n'}{range .status.conditions[*]}{.type}{'\t'}{.message}{'\n'}"

kubectl -n test-cluster get infraenvs.agent-install.openshift.io test-cluster -o=jsonpath="{.metadata.name}{'\n'}{range .status.conditions[*]}{.type}{'\t'}{.message}{'\n'}"

kubectl -n test-cluster get infraenvs.agent-install.openshift.io test-cluster -o=jsonpath="{.status.createdTime}{'\n'}{.status.isoDownloadURL}{'\n'}"

