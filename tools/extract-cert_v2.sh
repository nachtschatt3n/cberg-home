#!/bin/bash

# Define variables
NAMESPACE="networking"
SECRET_NAME="mathiasuhl-com-production-tls"
CERT_FILE="tls.crt"
KEY_FILE="tls.key"
KUBECONFIG_PATH="$HOME/.kube/config"

# Extract and decode the certificate-authority-data
CA_DATA=$(grep 'certificate-authority-data:' $KUBECONFIG_PATH | awk '{print $2}')
echo $CA_DATA | base64 --decode > ca.crt

# Extract and decode the client-certificate-data
CLIENT_CERT_DATA=$(grep 'client-certificate-data:' $KUBECONFIG_PATH | awk '{print $2}')
echo $CLIENT_CERT_DATA | base64 --decode > client.crt

# Extract and decode the client-key-data
CLIENT_KEY_DATA=$(grep 'client-key-data:' $KUBECONFIG_PATH | awk '{print $2}')
echo $CLIENT_KEY_DATA | base64 --decode > client.key

# Get the API server URL from the kubeconfig file
SERVER=$(grep 'server:' $KUBECONFIG_PATH | awk '{print $2}')

# Retrieve the secret using curl with the certificates
curl -s --cacert ca.crt --cert client.crt --key client.key \
"$SERVER/api/v1/namespaces/$NAMESPACE/secrets/$SECRET_NAME" -o secret.json

# Extract and decode the certificate and key
TLS_CRT=$(grep '"tls.crt":' secret.json | awk -F '"' '{print $4}')
TLS_KEY=$(grep '"tls.key":' secret.json | awk -F '"' '{print $4}')

echo $TLS_CRT | base64 --decode > $CERT_FILE
echo $TLS_KEY | base64 --decode > $KEY_FILE

# Clean up
rm ca.crt client.crt client.key secret.json

echo "Certificate and key have been written to $CERT_FILE and $KEY_FILE respectively."
