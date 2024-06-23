#!/bin/bash

# Define variables
SECRET_NAME="mathiasuhl-com-production-tls"
NAMESPACE="networking"
CERT_FILE="tls.crt"
KEY_FILE="tls.key"

# Get the secret in YAML format
SECRET_YAML=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o yaml)

# Extract the base64 encoded certificate and key using grep and awk
TLS_CRT=$(echo "$SECRET_YAML" | grep 'tls.crt:' | awk '{print $2}')
TLS_KEY=$(echo "$SECRET_YAML" | grep 'tls.key:' | awk '{print $2}')

# Decode the certificate and key and write them to files
echo $TLS_CRT | base64 --decode > $CERT_FILE
echo $TLS_KEY | base64 --decode > $KEY_FILE

echo "Certificate and key have been written to $CERT_FILE and $KEY_FILE respectively."
