
# 🚀 Deploying Minikube in GitHub Codespaces

This guide walks you through starting Minikube inside a GitHub Codespace and enabling external access.

---

## 🟢 Start Minikube

Run the following command to start Minikube using the Docker driver and bind the API server to all IPs:

```bash
minikube start --apiserver-ips=0.0.0.0 --driver=docker --force
```

## Minikube dashboard
For more information on how to make the Minikube dashboard accessible on all IPs (0.0.0.0), refer to [this link](https://unix.stackexchange.com/questions/621369/how-can-i-make-the-minikube-dashboard-answer-on-all-ips-0-0-0-0).

Open a new terminal and ensure the command runs continuously.
```bash
minikube dashboard --url
```

##  Enable External Access
To access Minikube from outside the Codespace:
1. Start the Kubernetes Proxy
```bash
kubectl proxy --address=0.0.0.0 --accept-hosts='.*'
```
2. **VERY IMPORTANT** Make port 8081 public if you need to connect your minikube from outside.

<img src="https://i.sstatic.net/YGIVx.png" alt="Set Public Port" width="50%">

3. Get the client.crt and client.key from ```/home/vscode/.minikube/profiles/minikube``` .