# Introduction 

This project enables you to seed a Hub cluster from scratch. The following items are created

* Creates the ACM Operator and installs the CRD
* Enables Sealed Secrets
* Enables VMware StorageClass
* Enables CIM sevice
* Enables Post-Install Policies
   > github Oauth
   
   > admin users from github

## Decrypt the Sealed secret key or create a new one

```
git clone https://github.com/waynedovey/Hub-ClusterSeed.git
```

```
cd Hub-ClusterSeed
```

### Ensure Ansible is installed (Password Available from Author)

```
ansible-vault decrypt sealed-secrets/hub.*
```

## Update the follow files for your environment

### VMware Variable 

```
Assisted-Installer-Storage/cloud-provider-config.yaml
```
```
Assisted-Installer-Storage/vsphere-creds-sealed.yaml
```
```
Assisted-Installer-Storage/vsphere-sc.yaml
```

### Authentication settings 

```
Post-Install/policy-cluster-admin-role.yaml
```
```
Post-Install/policy-github-oauth.yaml
```

## Run the Seed script

```
./seed-acm.sh
```

#### Reference SSL Certs

https://computingforgeeks.com/use-lets-encrypt-wildcard-certificates-on-openshift-ingress-routes/
