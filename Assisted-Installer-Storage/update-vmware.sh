#!/bin/bash

oc delete secrets vsphere-creds -n kube-system
oc apply -f Assisted-Installer-Storage/vsphere-creds-sealed.yaml
oc patch kubecontrollermanager cluster -p='{"spec": {"forceRedeploymentReason": "recovery-'"$( date --rfc-3339=ns )"'"}}' --type=merge
oc apply -f Assisted-Installer-Storage/cloud-provider-config.yaml

oc annotate sc thin storageclass.kubernetes.io/is-default-class-
oc apply -f Assisted-Installer-Storage/vsphere-sc.yaml
