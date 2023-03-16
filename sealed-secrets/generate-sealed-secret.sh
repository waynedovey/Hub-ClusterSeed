#!/bin/bash

export PRIVATEKEY="./sealed-secrets/hub.key"
export PUBLICKEY="./sealed-secrets/hub.crt"
export NAMESPACE="kube-system"
export SECRETNAME="hubkeys"

# Only for new Certs
#openssl req -x509 -days 365 -nodes -newkey rsa:4096 -keyout "$PRIVATEKEY" -out "$PUBLICKEY" -subj "/CN=sealed-secret/O=sealed-secret"

# Cleanup old one

kubectl -n "$NAMESPACE" delete secret -l sealedsecrets.bitnami.com/sealed-secrets-key=active
kubectl -n "$NAMESPACE" create secret tls "$SECRETNAME" --cert="$PUBLICKEY" --key="$PRIVATEKEY"
kubectl -n "$NAMESPACE" label secret "$SECRETNAME" sealedsecrets.bitnami.com/sealed-secrets-key=active

kubectl -n  "$NAMESPACE" delete pods -l app.kubernetes.io/name=sealed-secrets

sleep 30

kubectl -n "$NAMESPACE" logs -l app.kubernetes.io/name=sealed-secrets
