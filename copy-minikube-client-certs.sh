#!/bin/sh
# Script to package minikube client cert, key, and CA for remote use
set -e
PROFILE_DIR="$HOME/.minikube/profiles/minikube"
CA_PATH="$HOME/.minikube/ca.crt"
PACKAGE_DIR="$(dirname "$0")/minikube-client-certs"
PROJECT_ROOT="$(dirname "$0")"

mkdir -p "$PACKAGE_DIR"

if [ ! -f "$PROFILE_DIR/client.crt" ] || [ ! -f "$PROFILE_DIR/client.key" ]; then
  echo "Error: client.crt or client.key not found in $PROFILE_DIR"
  exit 1
fi
if [ ! -f "$CA_PATH" ]; then
  echo "Error: ca.crt not found in $HOME/.minikube"
  exit 1
fi

cp "$PROFILE_DIR/client.crt" "$PACKAGE_DIR/client.crt"
cp "$PROFILE_DIR/client.key" "$PACKAGE_DIR/client.key"
cp "$CA_PATH" "$PACKAGE_DIR/ca.crt"
cp "$HOME/.kube/config" "$PACKAGE_DIR/config"

cat > "$PACKAGE_DIR/README.txt" <<EOF
To use these certificates and kubeconfig to connect to your minikube cluster from another PC:

1. Copy client.crt, client.key, ca.crt, and config to your other PC.
2. Place config in ~/.kube/config on your other PC (or merge with your existing kubeconfig).
3. Make sure the paths in config for client-certificate, client-key, and certificate-authority are correct (edit if needed).
4. Make sure the minikube API server is accessible from your other PC (check firewall, use minikube tunnel, or expose the API server as needed).

Example kubeconfig user section:

users:
- name: minikube
  user:
    client-certificate: /path/to/client.crt
    client-key: /path/to/client.key
    auth-provider: null
clusters:
- name: minikube
  cluster:
    certificate-authority: /path/to/ca.crt

EOF

cd "$PACKAGE_DIR"
zip -r ../minikube-client-certs.zip .
echo "Created minikube-client-certs.zip in project root."
