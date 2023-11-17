#!/bin/bash

oc get nodes 2> /dev/null 

if [ $? -eq 0 ]
then
  oc create namespace open-cluster-management
  oc project open-cluster-management
  oc create secret generic eks-secret --from-file=.dockerconfigjson=sealed-secrets/pull-secret.txt --type=kubernetes.io/dockerconfigjson
  oc create -f ACM-install/operator-group.yaml
  oc create -f ACM-install/acm-operator-subscription.yaml
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
oc create -f ACM-install/custom-resource.yaml
until oc get mch -n open-cluster-management | grep Running 2> /dev/null
do
    echo echo "Wait for CRD Installation"
    sleep 30
done

# Enable Sealed Secrets 

sleep 120

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

oc apply -f ACM-CIM/agent_service_config.yaml
oc apply -f ACM-CIM/provisioning-configuration.yaml

# Enable Post-Install Policies 

oc apply -k Post-Install/
