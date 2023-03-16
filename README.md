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

### Ensure Ansible is installed 

```
ansible-vault decrypt sealed-secrets/hub.*
```

## Run the Seed script

```
./seed-acm.sh
```
