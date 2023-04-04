#!/bin/bash

oc get nodes 2> /dev/null 

if [ $? -eq 0 ]
then
  oc create namespace open-cluster-management
  oc project open-cluster-management
  oc create -f operator-group.yaml
  oc create -f acm-operator-subscription.yaml
else
  echo "Login into the OpenShift Cluster" >&2
  exit 1
fi

# Check progress of the Operator
until oc get csv -n open-cluster-management | grep Succeeded 2> /dev/null
do
    echo echo "Wait for Operator Installation"
    sleep 10
done

# Create the CRD
oc create -f custom-resource.yaml
until oc get mch -n open-cluster-management | grep Running 2> /dev/null
do
    echo echo "Wait for CRD Installation"
    sleep 30
done

# Enable Sealed Secrets 

oc apply -f sealed-secrets/sealed-secrets.yaml
until kubectl -n kube-system  get pods -l app.kubernetes.io/name=sealed-secrets | grep Running 2> /dev/null
do
    echo echo "Wait for Sealed Secret Installation"
    sleep 30
done

./sealed-secrets/generate-sealed-secret.sh

# Enable VMware StorageClass

#./Assisted-Installer-Storage/update-vmware.sh

# Enable CIM sevice

oc apply -f agent_service_config.yaml
oc apply -f provisioning-configuration.yaml

# Enable Post-Install Policies 

#oc apply -k Post-Install/
